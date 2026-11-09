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
        "<leader>e" = "open_float";
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
      virtual_text = false,
      virtual_lines = false,
      signs = true,
      underline = true,
      update_in_insert = false,
      float = { border = "rounded", source = "if_many" },
    })

    -- Show the current line's diagnostics when the cursor rests on it.
    vim.api.nvim_create_autocmd("CursorHold", {
      group = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true }),
      callback = function()
        vim.diagnostic.open_float({ focusable = false, scope = "line" })
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
