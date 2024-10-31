{ pkgs, inputs, mkKey, ... }:
let inherit (mkKey) mkKeymap;
in {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "Aiken";
      src = inputs.aiken;
    })
  ];
  # require'lspconfig'.aiken.setup({})
  extraConfigLua = # lua
    ''
    '';
}
