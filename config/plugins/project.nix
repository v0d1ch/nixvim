{mkKey,...}:
let
  inherit (mkKey) mkKeymap;
in {
  # project.nvim reads its history file during setup(), before nvim has
  # created stdpath("data") — on a fresh machine (empty $HOME) that aborts
  # the whole init.lua. Create the directory first.
  extraConfigLuaPre = /* lua */ ''
    vim.fn.mkdir(vim.fn.stdpath("data"), "p")
  '';

  plugins.project-nvim = {
    enable = true;
  };
  keymaps = [
      (mkKeymap "n" "<leader>p" "<cmd>Telescope projects<cr>" "Select a project" )
  ];
}
