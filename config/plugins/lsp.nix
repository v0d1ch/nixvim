{ pkgs, ... }: {
  # gopls needs the Go toolchain on Neovim's PATH to inspect modules.
  extraPackages = [ pkgs.go ];

  plugins.lsp = {
    enable = true;
    servers = {
      gopls.enable = true;
      hls = {
        enable = true;
        installGhc = false;
        settings = {
          haskell.plugin.semanticTokens.globalOn = true;
        };
      };
      # The whole Rust toolchain, rust-analyzer included, comes from the
      # project's flake dev shell so it matches the project's rustc. Bundling
      # nixpkgs' rust-analyzer here would shadow it: nixvim prepends server
      # packages to PATH.
      rust_analyzer = {
        enable = true;
        package = null;
        installCargo = false;
        installRustc = false;
      };
    };
    keymaps = {
      lspBuf = {
        "K" = "hover";
        "<leader>d" = "definition";
        "<leader>t" = "type_definition";
        "<leader>a" = "code_action";
      };
      diagnostic = {
        "<leader>z" = "setloclist";
      };
    };
  };

  plugins.cmp.settings = {
    sources = [
      { name = "nvim_lsp"; }
      { name = "buffer"; }
    ];
    mapping = {
      "<CR>" = "cmp.mapping.confirm({ select = false })";
      "<Tab>" = ''
        cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif require('copilot.suggestion').is_visible() then
            require('copilot.suggestion').accept()
          else
            fallback()
          end
        end, {'i', 's'})
      '';
      "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
      "<Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
      "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
    };
  };

  extraConfigLua = ''
    vim.diagnostic.config({
      virtual_text = function(_, bufnr) return vim.bo[bufnr].filetype ~= "haskell" end,
      ["haskell/wrapped"] = true,
      signs = true,
      underline = true,
      update_in_insert = false,
    })

    -- HLS messages are often longer than the space remaining after a code line.
    -- Draw them below the line and wrap them to the width of the editor window.
    local wrapped_namespaces = {}

    local function wrapped_namespace(namespace)
      if not wrapped_namespaces[namespace] then
        wrapped_namespaces[namespace] = vim.api.nvim_create_namespace("haskell/wrapped/" .. namespace)
      end
      return wrapped_namespaces[namespace]
    end

    local function wrap_message(message, width)
      local lines = {}
      for source_line in (message .. "\n"):gmatch("(.-)\n") do
        local line = ""
        for word in source_line:gmatch("%S+") do
          if line ~= "" and vim.fn.strdisplaywidth(line .. " " .. word) > width then
            table.insert(lines, line)
            line = ""
          end
          while vim.fn.strdisplaywidth(word) > width do
            local chunk = vim.fn.strcharpart(word, 0, width)
            table.insert(lines, chunk)
            word = vim.fn.strcharpart(word, width)
          end
          line = line == "" and word or (line .. " " .. word)
        end
        table.insert(lines, line)
      end
      return lines
    end

    local function show_haskell_diagnostics(namespace, bufnr, diagnostics)
      local wrapped_ns = wrapped_namespace(namespace)
      vim.api.nvim_buf_clear_namespace(bufnr, wrapped_ns, 0, -1)
      if vim.bo[bufnr].filetype ~= "haskell" then return end

      local win = vim.fn.bufwinid(bufnr)
      local width = (win ~= -1 and vim.api.nvim_win_get_width(win) or vim.o.columns) - 4
      width = math.max(width, 1)
      local by_line = {}
      local highlights = {
        [vim.diagnostic.severity.ERROR] = "DiagnosticVirtualLinesError",
        [vim.diagnostic.severity.WARN] = "DiagnosticVirtualLinesWarn",
        [vim.diagnostic.severity.INFO] = "DiagnosticVirtualLinesInfo",
        [vim.diagnostic.severity.HINT] = "DiagnosticVirtualLinesHint",
      }

      for _, diagnostic in ipairs(diagnostics) do
        local line = diagnostic.lnum
        by_line[line] = by_line[line] or {}
        local highlight = highlights[diagnostic.severity]
        local prefix = "╰─ "
        for _, part in ipairs(wrap_message(diagnostic.message, width)) do
          table.insert(by_line[line], { { prefix .. part, highlight } })
          prefix = "   "
        end
      end

      for line, virtual_lines in pairs(by_line) do
        vim.api.nvim_buf_set_extmark(bufnr, wrapped_ns, line, 0, {
          virt_lines = virtual_lines,
          virt_lines_leftcol = true,
        })
      end
    end

    vim.diagnostic.handlers["haskell/wrapped"] = {
      show = show_haskell_diagnostics,
      hide = function(namespace, bufnr)
        vim.api.nvim_buf_clear_namespace(bufnr, wrapped_namespace(namespace), 0, -1)
      end,
    }

    vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
      callback = function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local bufnr = vim.api.nvim_win_get_buf(win)
          if vim.bo[bufnr].filetype == "haskell" then
            vim.diagnostic.show(nil, bufnr)
          end
        end
      end,
    })

  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>i";
      action.__raw = ''function() vim.lsp.buf.hover({ border = "rounded" }) end'';
      options.desc = "Show type information";
    }
  ];
}
