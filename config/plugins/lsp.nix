{ ... }: {
  plugins.lsp = {
    enable = true;
    servers = {
      hls = {
        enable = true;
        installGhc = false;
      };
      rust_analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
      };
    };
    keymaps = {
      lspBuf = {
        "K" = "hover";
        "<leader>h" = "hover";
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
      "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
      "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
      "<Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
      "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
    };
  };

  extraConfigLua = ''
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
    })
  '';
}
