{
  # "Typewriter" — a light, custom colorscheme with no upstream plugin,
  # matched to the Obsidian "Typewriter" community theme (crashmoney) in
  # light mode: cream canvas (#fcf5e4), neutral near-black ink (#262626),
  # green accent (#459f58) for links/cursor, light-blue selection (#cce6ff),
  # code-block tone (#eee8d5) with blue code text. Same palette as the
  # ghostty/herdr "typewriter" themes in the dotfiles repo. Activate via
  # `colorscheme = "typewriter"` in options/color.nix (or `:colorscheme
  # typewriter` at runtime).
  extraFiles."colors/typewriter.lua".text = /* lua */ ''
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") == 1 then
      vim.cmd("syntax reset")
    end
    vim.o.background = "light"
    vim.o.termguicolors = true
    vim.g.colors_name = "typewriter"

    local c = {
      bg         = "#fcf5e4", -- canvas (--background-primary)
      bg_alt     = "#f5eedb", -- CursorLine / ColorColumn
      bg_dim     = "#eee8d5", -- floats, Pmenu, inline code (--code-background)
      bg_dark    = "#e4dcc8", -- StatusLine (--background-secondary)
      bg_darker  = "#d6cdb5", -- EndOfBuffer
      border     = "#c2c2c2", -- (--background-modifier-border-focus)
      ink        = "#262626", -- fg (--text-normal)
      ink_muted  = "#595959", -- Comment / LineNr (--text-muted)
      dim        = "#7d7d7d", -- Operator / punctuation
      faint      = "#9e9e9e", -- (--text-faint)
      paper      = "#fffcf2", -- near-white, text on solid accents
      sel        = "#cce6ff", -- Visual (--text-selection)
      hl_yellow  = "#fdeb72", -- Search (--text-highlight-bg over canvas)
      hl_orange  = "#fdc689", -- IncSearch (--text-highlight-bg-active over canvas)
      -- Accents: Typewriter's Monokai-derived code palette (blue #6c99bb,
      -- purple #9e86c8, orange #e87d3e, yellow #e5b567, pink #b05279) darkened
      -- to read on cream, plus its green accent. Tuned for red/green color
      -- vision — green is a dark emerald told apart by luminance, cyan is a
      -- teal so it never blends with green, yellow leans ochre.
      accent     = "#459f58", -- Typewriter green accent (links, cursor)
      red        = "#b83232",
      green      = "#2f7a48",
      yellow     = "#9a6b12",
      blue       = "#3d6d99",
      magenta    = "#6e56a6",
      cyan       = "#2b7d78",
      orange     = "#c25a20",
      pink       = "#b05279",
      red_l      = "#e63c3c", -- (--text-error)
      green_l    = "#459f58",
      yellow_l   = "#b8842a",
      blue_l     = "#6c99bb", -- (--code-normal)
      magenta_l  = "#8a70c0",
      cyan_l     = "#3f9a94",
      diff_add   = "#d9ead1",
      diff_chg   = "#f6ecc0",
      diff_del   = "#f3d1cc",
      diff_txt   = "#cce6ff",
    }

    local hl = function(group, opts) vim.api.nvim_set_hl(0, group, opts) end

    -- Editor UI
    hl("Normal",       { fg = c.ink, bg = c.bg })
    hl("NormalFloat",  { fg = c.ink, bg = c.bg_dim })
    hl("FloatBorder",  { fg = c.border, bg = c.bg_dim })
    hl("Cursor",       { fg = c.bg, bg = c.accent })
    hl("CursorLine",   { bg = c.bg_alt })
    hl("CursorLineNr", { fg = c.ink, bold = true })
    hl("LineNr",       { fg = c.faint })
    hl("SignColumn",   { bg = c.bg })
    hl("ColorColumn",  { bg = c.bg_alt })
    hl("Visual",       { bg = c.sel })
    hl("Search",       { bg = c.hl_yellow, fg = c.ink, underline = true, sp = c.accent })
    hl("IncSearch",    { bg = c.hl_orange, fg = c.ink, bold = true, underline = true, sp = c.orange })
    hl("MatchParen",   { bg = c.hl_yellow, fg = c.ink, bold = true })
    hl("StatusLine",   { fg = c.ink, bg = c.bg_dark })
    hl("StatusLineNC", { fg = c.ink_muted, bg = c.bg_dim })
    hl("TabLine",      { fg = c.ink_muted, bg = c.bg_dim })
    hl("TabLineSel",   { fg = c.ink, bg = c.bg, bold = true })
    hl("TabLineFill",  { bg = c.bg_dim })
    hl("VertSplit",    { fg = c.border, bg = c.bg })
    hl("WinSeparator", { fg = c.border, bg = c.bg })
    hl("Pmenu",        { fg = c.ink, bg = c.bg_dim })
    hl("PmenuSel",     { fg = c.paper, bg = c.green, bold = true })
    hl("PmenuSbar",    { bg = c.bg_dark })
    hl("PmenuThumb",   { bg = c.border })
    hl("NonText",      { fg = c.border })
    hl("EndOfBuffer",  { fg = c.bg_darker })
    hl("Directory",    { fg = c.green, bold = true })
    hl("Title",        { fg = c.ink, bold = true })
    hl("Todo",         { bg = c.hl_yellow, fg = c.ink, bold = true })
    hl("ErrorMsg",     { fg = c.paper, bg = c.red, bold = true })
    hl("WarningMsg",   { fg = c.yellow })

    -- Syntax
    hl("Comment",    { fg = c.ink_muted, italic = true })
    hl("Constant",   { fg = c.orange })
    hl("String",     { fg = c.green, bold = true })
    hl("Character",  { fg = c.green, bold = true })
    hl("Number",     { fg = c.orange, bold = true })
    hl("Boolean",    { fg = c.orange, bold = true })
    hl("Identifier", { fg = c.ink })
    hl("Function",   { fg = c.blue, bold = true })
    hl("Statement",  { fg = c.magenta, bold = true })
    hl("Conditional",{ fg = c.magenta })
    hl("Repeat",     { fg = c.magenta })
    hl("Keyword",    { fg = c.magenta, bold = true })
    hl("Operator",   { fg = c.dim })
    hl("PreProc",    { fg = c.pink })
    hl("Include",    { fg = c.magenta })
    hl("Type",       { fg = c.yellow, bold = true })
    hl("StorageClass",{ fg = c.yellow })
    hl("Structure",  { fg = c.yellow })
    hl("Special",    { fg = c.cyan })
    hl("Underlined", { fg = c.accent, underline = true })
    hl("Error",      { fg = c.paper, bg = c.red, bold = true })

    -- Diff
    hl("DiffAdd",    { bg = c.diff_add })
    hl("DiffChange", { bg = c.diff_chg })
    hl("DiffDelete", { bg = c.diff_del, fg = c.ink_muted })
    hl("DiffText",   { bg = c.diff_txt, bold = true })

    -- Diagnostics
    hl("DiagnosticError", { fg = c.red })
    hl("DiagnosticWarn",  { fg = c.yellow })
    hl("DiagnosticInfo",  { fg = c.blue })
    hl("DiagnosticHint",  { fg = c.cyan })
    hl("DiagnosticUnderlineError", { sp = c.red, underline = true })
    hl("DiagnosticUnderlineWarn",  { sp = c.yellow, underline = true })
    hl("DiagnosticUnderlineInfo",  { sp = c.blue, underline = true })
    hl("DiagnosticUnderlineHint",  { sp = c.cyan, underline = true })

    -- Gitsigns
    hl("GitSignsAdd",         { fg = c.green })
    hl("GitSignsChange",      { fg = c.yellow })
    hl("GitSignsDelete",      { fg = c.red })
    hl("GitSignsChangedelete",{ fg = c.orange })
    hl("GitSignsTopdelete",   { fg = c.red })

    -- Treesitter captures
    hl("@comment",           { link = "Comment" })
    hl("@string",            { link = "String" })
    hl("@string.escape",     { fg = c.cyan })
    hl("@number",            { link = "Number" })
    hl("@boolean",           { link = "Boolean" })
    hl("@function",          { link = "Function" })
    hl("@function.call",     { link = "Function" })
    hl("@function.builtin",  { fg = c.blue, italic = true })
    hl("@keyword",           { link = "Keyword" })
    hl("@keyword.function",  { link = "Keyword" })
    hl("@keyword.return",    { link = "Keyword" })
    hl("@conditional",       { link = "Conditional" })
    hl("@repeat",            { link = "Repeat" })
    hl("@type",              { link = "Type" })
    hl("@type.builtin",      { fg = c.yellow, italic = true })
    hl("@constant",          { link = "Constant" })
    hl("@constant.builtin",  { fg = c.orange, bold = true })
    hl("@variable",          { fg = c.ink })
    hl("@variable.builtin",  { fg = c.cyan, italic = true })
    hl("@parameter",         { fg = c.ink, italic = true })
    hl("@property",          { fg = c.cyan })
    hl("@field",             { fg = c.cyan })
    hl("@constructor",       { fg = c.yellow, bold = true })
    hl("@tag",               { fg = c.red })
    hl("@tag.attribute",     { fg = c.yellow })
    hl("@tag.delimiter",     { fg = c.dim })
    hl("@punctuation.delimiter", { fg = c.dim })
    hl("@punctuation.bracket",   { fg = c.dim })
    hl("@operator",          { link = "Operator" })
    hl("@namespace",         { fg = c.yellow })
    hl("@include",           { link = "Include" })
    hl("@preproc",           { link = "PreProc" })

    -- Markup (markdown/Obsidian-like): headings are plain bold ink,
    -- links green, inline code blue on the code-block tone — as in Typewriter.
    hl("@markup.heading",    { fg = c.ink, bold = true })
    hl("@markup.strong",     { bold = true })
    hl("@markup.italic",     { italic = true })
    hl("@markup.link",       { fg = c.accent })
    hl("@markup.link.url",   { fg = c.accent, underline = true })
    hl("@markup.link.label", { fg = c.green })
    hl("@markup.raw",        { fg = c.blue, bg = c.bg_dim })
    hl("@markup.raw.block",  { fg = c.blue })
    hl("@markup.quote",      { fg = c.ink_muted, italic = true })
    hl("@markup.list",       { fg = c.dim })
  '';
}
