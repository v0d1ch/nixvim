{pkgs, ...}:
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "nvim-lspconfig";
      src = inputs.nvim-lspconfig;
    })
  ];
}
