{pkgs, inputs, ...}: {
    plugins.neogit = {
        enable = true;
        package = pkgs.vimPlugins.neogit.overrideAttrs rec {
            src = inputs.neogit;
            version = "unstable-${inputs.neogit.shortRev}";
            name = "vimplugin-neogit-${version}";
        };
        settings = {
            integrations = {
                diffview = true;
            };
        };
    };
    plugins.undotree.enable = true;
    # plugins.vimtex.enable = true;
    plugins.cmp.enable = true;
    plugins.markdown-preview.enable = true;
    # plugins.illuminate.enable = true;
    # plugins.hardtime.enable = true;
    plugins.diffview.enable = true;
    # plugins.treesitter.enable = true;
    plugins.web-devicons.enable = true;
    plugins.mini.enable = true;
    plugins.fugitive.enable = true;
}
