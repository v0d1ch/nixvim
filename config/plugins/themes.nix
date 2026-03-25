{ pkgs, ... }:
{
  # Install all themes as plugins without activating them.
  # Active theme is controlled by base16 in color.nix.
  # Switch at runtime with :Telescope colorscheme (session only) or change color.nix + rebuild to persist.
  extraPlugins = with pkgs.vimPlugins; [
    tokyonight-nvim
    catppuccin-nvim
    rose-pine
    kanagawa-nvim
    nightfox-nvim
    onedark-nvim
    gruvbox-nvim
    github-nvim-theme
  ];
}
