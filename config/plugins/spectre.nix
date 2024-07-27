{mkKey,...}:
let
  inherit (mkKey) mkKeymap;
in {
    plugins.spectre.enable = true; 

    keymaps = [
      (mkKeymap "n" "<leader>S" "<cmd>lua require('spectre').toggle()<CR>" "Toggle Spectre" )
      (mkKeymap "n" "<leader>w" "<cmd>lua require('spectre').open_visual({select_word=true})<CR>" "Search current word" )
      (mkKeymap "n" "<leader>cw" "<cmd>lua require('spectre').open_file_search({select_word=true})<CR>" "Search current word in file" )
    ];
}
