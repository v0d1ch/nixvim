{ pkgs, ... }:
{
  # Agda's editing model is nothing like an LSP: you leave `?` holes in the
  # file and drive them interactively — load, inspect the goal and context,
  # case split, refine — until no holes are left. cornelis speaks Agda's
  # interaction protocol to do that from Neovim.
  #
  # It shells out to two binaries. cornelis itself lives here so the editor is
  # self-contained; the `agda` binary (with the standard library and
  # agda2hs-base) comes from home.packages in the dotfiles repo, since it is
  # also used from the shell.
  extraPackages = [ pkgs.cornelis ];

  extraPlugins = with pkgs.vimPlugins; [
    cornelis
    # cornelis has no input method of its own, and Agda is unusable without
    # one — real code is full of →, ∀, ℕ, ≡. julia-vim's LaTeX-to-Unicode
    # substitution is the pairing the cornelis README suggests: type \to and
    # it becomes → as you go.
    julia-vim
  ];

  # Globals have to be set before the plugins load, hence Pre.
  extraConfigLuaPre = # lua
    ''
      -- Use the cornelis from extraPackages above rather than letting the
      -- plugin look for a build of its own.
      vim.g.cornelis_use_global_binary = 1

      -- julia-vim would otherwise hijack <Tab> everywhere and turn LaTeX into
      -- Unicode in every buffer. Restrict it to Agda and leave <Tab> alone.
      vim.g.latex_to_unicode_tab = 0
      vim.g.latex_to_unicode_auto = 1
      vim.g.latex_to_unicode_file_types = { "agda" }
    '';

  # Agda highlighting needs no setup here: plugins.treesitter.grammarPackages
  # defaults to nvim-treesitter's allGrammars, which already ships the Agda
  # parser, and treesitter.nix does not narrow that list.
  extraConfigLua = # lua
    ''
      -- All of this is meaningless outside an Agda buffer, so keep it
      -- buffer-local instead of spending global leader keys on it. Everything
      -- sits under <leader>a; [g / ]g move between holes and are bare because
      -- you hit them constantly and nothing else claims them.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "agda",
        desc = "cornelis (Agda) interaction mappings",
        callback = function(ev)
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, {
              buffer = ev.buf, silent = true, noremap = true, desc = desc,
            })
          end

          -- Typecheck the buffer. The one you press after every edit.
          map("<leader>al", "<cmd>CornelisLoad<cr>",            "Agda: load file")
          -- Fill the hole under the cursor with whatever is forced by its type.
          map("<leader>ar", "<cmd>CornelisRefine<cr>",          "Agda: refine goal")
          -- Split the pattern variable under the cursor into its constructors.
          map("<leader>ac", "<cmd>CornelisMakeCase<cr>",        "Agda: case split")
          -- Commit the hole's current contents as the solution.
          map("<leader>ag", "<cmd>CornelisGive<cr>",            "Agda: give solution")
          -- Goal type plus everything in scope: the window you live in.
          map("<leader>at", "<cmd>CornelisTypeContext<cr>",     "Agda: goal type & context")
          map("<leader>aT", "<cmd>CornelisTypeContextInfer<cr>","Agda: infer type in goal")
          map("<leader>aa", "<cmd>CornelisAuto<cr>",            "Agda: auto-solve goal")
          map("<leader>as", "<cmd>CornelisSolve<cr>",           "Agda: solve constraints")
          map("<leader>an", "<cmd>CornelisNormalize<cr>",       "Agda: normalize expression")
          map("<leader>aw", "<cmd>CornelisWhyInScope<cr>",      "Agda: why is this in scope")
          map("<leader>a?", "<cmd>CornelisGoals<cr>",           "Agda: list all goals")
          map("<leader>ad", "<cmd>CornelisGoToDefinition<cr>",  "Agda: go to definition")
          map("<leader>aq", "<cmd>CornelisCloseInfoWindows<cr>","Agda: close info windows")
          -- The Agda process keeps state; restart it when it wedges.
          map("<leader>aR", "<cmd>CornelisRestart<cr>",         "Agda: restart process")

          map("[g", "<cmd>CornelisPrevGoal<cr>", "Agda: previous goal")
          map("]g", "<cmd>CornelisNextGoal<cr>", "Agda: next goal")
        end,
      })
    '';
}
