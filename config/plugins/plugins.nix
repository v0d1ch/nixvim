{lib, ...}: {
    plugins.neogit = {
        enable = true;
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
    plugins.avante.enable = true;
    plugins.avante.settings = {
        provider = "copilot";
    };
    # avante's copilot provider hard-errors inside setup() when no GitHub
    # Copilot token exists yet (fresh machine, before :Copilot auth), which
    # would abort the rest of init.lua. Replace the generated setup call with
    # a pcall'd one; keep the settings here in sync with the ones above.
    plugins.avante.luaConfig.content = lib.mkForce /* lua */ ''
      require("avante_lib").load()
      local ok, err = pcall(require("avante").setup, { provider = "copilot" })
      if not ok then
        -- Notify only once a UI attaches: headless runs (like the flake
        -- check, whose sandbox can never have a copilot token) treat any
        -- stderr output as failure, and UIEnter never fires there
        vim.api.nvim_create_autocmd("UIEnter", {
          once = true,
          callback = function()
            vim.notify("avante disabled: " .. tostring(err), vim.log.levels.WARN)
          end,
        })
      end
    '';
}
