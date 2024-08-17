{
    plugins.neogit.enable = true;
    plugins.coq-nvim.enable = true;
    plugins.undotree.enable = true;
    plugins.vimtex.enable = true;
    plugins.cmp.enable = true;
    plugins.markdown-preview.enable = true;
    plugins.illuminate.enable = true;
    plugins.hardtime.enable = true;
    plugins.diffview.enable = true;
    plugins.lsp.servers.rust-analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
    };
}
