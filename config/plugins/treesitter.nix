{ pkgs, ... }: {
  plugins = {
    treesitter = {
      enable = true;
      settings.indent.enable = true;
      settings.highlight = {
        enable = true;
        additional_vim_regex_highlighting = false;
      };
      nixvimInjections = true;
      settings.incremental_selection.enable = true;
    };
    treesitter-textobjects = { enable = true; };
    mini.enable = true;
    indent-blankline = {
      enable = true;
      settings = {
        exclude = {
          filetypes = [
            "dashboard"
            "lspinfo"
            "packer"
            "checkhealth"
            "help"
            "man"
            "gitcommit"
            "TelescopePrompt"
            "TelescopeResults"
            "''"
          ];
        };
        indent = { char = "│"; };
      };
    };
  };

  extraPlugins = with pkgs.vimPlugins; [ nvim-treesitter-textsubjects ];

  extraConfigLua = ''
    -- Stock tokyonight gives Haskell constructors the same magenta as
    -- keywords, so they do not stand out. Applies to tokyonight variants
    -- only; other colorschemes reset these groups when they load.
    local function haskell_pop()
      local name = vim.g.colors_name or ""
      if not name:match("^tokyonight") then return end
      -- treesitter captures
      vim.api.nvim_set_hl(0, "@constructor.haskell", { fg = "#ff9e64", bold = true })
      vim.api.nvim_set_hl(0, "@function.haskell", { fg = "#7aa2f7", bold = true })
      vim.api.nvim_set_hl(0, "@type.haskell", { fg = "#2ac3de", bold = true })
      -- HLS semantic tokens, layered on top once the LSP attaches
      vim.api.nvim_set_hl(0, "@lsp.type.function.haskell", { fg = "#7aa2f7", bold = true })
      vim.api.nvim_set_hl(0, "@lsp.type.enumMember.haskell", { fg = "#ff9e64", bold = true })
    end
    vim.api.nvim_create_autocmd("ColorScheme", { callback = haskell_pop })
    haskell_pop()

    require('mini.indentscope').setup({
      symbol = "│",
    })

    require("nvim-treesitter.configs").setup({
      textsubjects = {
        enable = true,
        prev_selection = ",", -- (Optional) keymap to select the previous selection
        keymaps = {
          ["."] = "textsubjects-smart",
          [";"] = "textsubjects-container-outer",
          ["i;"] = { "textsubjects-container-inner", desc = "Select inside containers (classes, functions, etc.)" },
        },
      },
    })
  '';
}
