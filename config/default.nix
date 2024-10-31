{
  # Import all your configuration modules here
  imports =
    [ ./options/options.nix
      ./options/keymap.nix
      ./options/color.nix
      ./autocmd.nix
      ./plugins/solarized.nix
      ./plugins/tokyodark.nix
      ./plugins/papercolor.nix
      ./plugins/treesitter.nix
      ./plugins/nvim-tree.nix
      ./plugins/oil.nix
      ./plugins/gitsigns.nix
      ./plugins/git-conflict.nix
      ./plugins/ufo.nix
      ./plugins/comment.nix
      ./plugins/ctrlsf.nix
      ./plugins/spectre.nix
      ./plugins/dashboard.nix
      ./plugins/lualine.nix
      ./plugins/telescope.nix 
      ./plugins/coc-nvim.nix
      ./plugins/copilot.nix
      ./plugins/project.nix
      ./plugins/obsidian.nix
      ./plugins/session.nix
      ./plugins/aiken.nix
      ./plugins/plugins.nix
      # ./plugins/tokyodark.nix 
      # ./plugins/harpoon.nix
      # ./plugins/bufferline.nix
    ];
}
