{ pkgs, inputs, mkKey, ... }:
let inherit (mkKey) mkKeymap;
in {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "Tree Sitter Haskell parser";
      src = inputs.tree-sitter-haskell;
    })
  ];
