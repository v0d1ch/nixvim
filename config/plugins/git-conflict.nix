{mkKey,...}:
let
  inherit (mkKey) mkKeymap;
in {
  plugins.git-conflict = {
    enable = true;
  };
  keymaps = [
    (mkKeymap "n" "<leader>cn" "<cmd>GitConflictNextConflict<cr>" "goto next conflict" )
    (mkKeymap "n" "<leader>cp" "<cmd>GitConflictPrevConflict<cr>" "goto prev conflict" )
    (mkKeymap "n" "<leader>co" "<cmd>GitConflictChooseOurs<cr>" "choose ours" )
    (mkKeymap "n" "<leader>ct" "<cmd>GitConflictChooseTheirs<cr>" "choose theirs" )
    (mkKeymap "n" "<leader>cb" "<cmd>GitConflictChooseBoth<cr>" "choose both" )
    (mkKeymap "n" "<leader>cx" "<cmd>GitConflictChooseNone<cr>" "choose none" )
    (mkKeymap "n" "<leader>cr" "<cmd>GitConflictRefresh<cr>" "refresh" )
  ];
}
