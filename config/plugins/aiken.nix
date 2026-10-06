{ pkgs, inputs, ... }:
{
  # Aiken (Cardano smart contract language, *.ak files).
  #
  # nvim-treesitter has no Aiken grammar and nixpkgs does not package the
  # editor plugin, so the upstream vim plugin is pulled in as a flake input.
  # It provides filetype detection (*.ak -> aiken), regex syntax highlighting
  # and indentation. Since there is no treesitter parser for the filetype the
  # regex syntax is used as-is; treesitter's
  # additional_vim_regex_highlighting=false only affects buffers that have a
  # parser.
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "aiken-vim";
      src = inputs.aiken;
    })
  ];

  # `aiken lsp`, via nvim-lspconfig's aiken server. nixvim installs the
  # `aiken` binary from nixpkgs into neovim's PATH for it; the shell gets its
  # own copy from home.packages in the dotfiles repo if needed.
  plugins.lsp.servers.aiken.enable = true;

  extraConfigLua = # lua
    ''
      -- Format *.ak on save through the LSP, as the upstream README suggests.
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.ak",
        desc = "Aiken: format on save",
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    '';
}
