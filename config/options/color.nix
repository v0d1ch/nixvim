{
  # Default theme: Typewriter (light, custom — see plugins/typewriter.nix;
  # matched to the Obsidian "Typewriter" theme: cream + neutral ink + green
  # accent). Toggle light/dark at runtime with <leader>tt (or :ToggleTheme).
  # To change the default permanently, edit `colorscheme` below and rebuild.
  # Available (installed via plugins/themes.nix): tokyonight, catppuccin, rose-pine,
  #            kanagawa, nightfox, carbonfox, duskfox, nordfox, dayfox, onedark,
  #            gruvbox, github_dark, github_dark_default, github_dark_dimmed,
  #            github_dark_high_contrast, github_dark_colorblind, github_light,
  #            tokyonight-day, tokyonight-moon, catppuccin-latte, rose-pine-dawn,
  #            kanagawa-wave, kanagawa-lotus, paper (plugins/paper.nix, light-only),
  #            typewriter (plugins/typewriter.nix, light-only)
  colorscheme = "typewriter";
  opts.background = "light";

  extraConfigLua = /* lua */ ''
    -- Search highlights tuned per background, reapplied on every colorscheme change
    local function search_highlights()
      if vim.g.colors_name == "typewriter" then
        -- Obsidian Typewriter highlight yellow / active orange over the cream canvas
        vim.api.nvim_set_hl(0, "Search", { bg = "#fdeb72", fg = "#262626", underline = true, sp = "#459f58" })
        vim.api.nvim_set_hl(0, "IncSearch", { bg = "#fdc689", fg = "#262626", bold = true, underline = true, sp = "#c25a20" })
      elseif vim.o.background == "light" then
        vim.api.nvim_set_hl(0, "Search", { bg = "#ddbf62", fg = "#322e26", underline = true, sp = "#3a618c" })
        vim.api.nvim_set_hl(0, "IncSearch", { bg = "#85621c", fg = "#faf5e9", bold = true, underline = true, sp = "#9c531f" })
      else
        vim.api.nvim_set_hl(0, "Search", { bg = "#1e3a5f", fg = "#d2d2d2", underline = true, sp = "#51afef" })
        vim.api.nvim_set_hl(0, "IncSearch", { bg = "#5a4a00", fg = "#ffffff", bold = true, underline = true, sp = "#ECBE7B" })
      end
    end
    vim.api.nvim_create_autocmd("ColorScheme", { callback = search_highlights })
    search_highlights()

    -- Toggle between Typewriter (light) and GitHub Dark
    local function toggle_theme()
      if vim.o.background == "light" then
        vim.o.background = "dark"
        vim.cmd.colorscheme("github_dark_colorblind")
      else
        vim.o.background = "light"
        vim.cmd.colorscheme("typewriter")
      end
    end
    vim.api.nvim_create_user_command("ToggleTheme", toggle_theme, {})
    vim.keymap.set("n", "<leader>tt", toggle_theme, { desc = "Toggle light/dark theme" })
  '';
}
