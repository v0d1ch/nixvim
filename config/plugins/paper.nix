{
  # "Paper" — a light, custom colorscheme with no upstream plugin.
  # Background pinned to the current macOS desktop wallpaper color
  # (rgb 190 191 196 / #bebfc4), matching the ghostty/herdr themes set
  # alongside this flake. Activate via `colorscheme = "paper"` in
  # options/color.nix (or `:colorscheme paper` at runtime).
  extraFiles."colors/paper.lua".text = /* lua */ ''
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") == 1 then
      vim.cmd("syntax reset")
    end
    vim.o.background = "light"
    vim.o.termguicolors = true
    vim.g.colors_name = "paper"

    local c = {
      bg         = "#bebfc4", -- canvas (= wallpaper)
      bg_dim     = "#b3b4b9", -- subtle panel / CursorLine
      bg_dark    = "#a6a7ac", -- Visual / StatusLineNC
      bg_darker  = "#97989e", -- inset / NonText
      border     = "#8b8c92",
      ink        = "#202125", -- fg
      ink_muted  = "#55565c", -- Comment / LineNr
      dim        = "#6e6f76",
      paper      = "#f4f4f5", -- near-white highlight
      red        = "#a6353b",
      green      = "#4b7a3d",
      yellow     = "#8a6d1f",
      blue       = "#35618a",
      magenta    = "#7a4b7a",
      cyan       = "#2e7a79",
      orange     = "#9c5a2e",
      red_l      = "#c24950",
      green_l    = "#63a050",
      yellow_l   = "#a88a2e",
      blue_l     = "#4c7eae",
      magenta_l  = "#9a639a",
      cyan_l     = "#3e9c9a",
      diff_add   = "#c3d6bd",
      diff_chg   = "#cdd0d8",
      diff_del   = "#d8bcbe",
      diff_txt   = "#b8c8e0",
    }

    local hl = function(group, opts) vim.api.nvim_set_hl(0, group, opts) end

    -- Editor UI
    hl("Normal",       { fg = c.ink, bg = c.bg })
    hl("NormalFloat",  { fg = c.ink, bg = c.bg_dim })
    hl("FloatBorder",  { fg = c.border, bg = c.bg_dim })
    hl("Cursor",       { fg = c.bg, bg = c.ink })
    hl("CursorLine",   { bg = c.bg_dim })
    hl("CursorLineNr", { fg = c.ink, bold = true })
    hl("LineNr",       { fg = c.ink_muted })
    hl("SignColumn",   { bg = c.bg })
    hl("ColorColumn",  { bg = c.bg_dim })
    hl("Visual",       { bg = c.bg_dark })
    hl("Search",       { bg = c.yellow_l, fg = c.ink, underline = true, sp = c.blue })
    hl("IncSearch",    { bg = c.yellow, fg = c.paper, bold = true, underline = true, sp = c.orange })
    hl("MatchParen",   { bg = c.yellow_l, fg = c.ink, bold = true })
    hl("StatusLine",   { fg = c.ink, bg = c.bg_dark })
    hl("StatusLineNC", { fg = c.ink_muted, bg = c.bg_dim })
    hl("TabLine",      { fg = c.ink_muted, bg = c.bg_dim })
    hl("TabLineSel",   { fg = c.ink, bg = c.bg, bold = true })
    hl("TabLineFill",  { bg = c.bg_dim })
    hl("VertSplit",    { fg = c.border, bg = c.bg })
    hl("WinSeparator", { fg = c.border, bg = c.bg })
    hl("Pmenu",        { fg = c.ink, bg = c.bg_dim })
    hl("PmenuSel",     { fg = c.paper, bg = c.blue, bold = true })
    hl("PmenuSbar",    { bg = c.bg_dark })
    hl("PmenuThumb",   { bg = c.border })
    hl("NonText",      { fg = c.bg_darker })
    hl("EndOfBuffer",  { fg = c.bg_darker })
    hl("Directory",    { fg = c.blue, bold = true })
    hl("Todo",         { bg = c.yellow_l, fg = c.ink, bold = true })
    hl("ErrorMsg",     { fg = c.paper, bg = c.red, bold = true })
    hl("WarningMsg",   { fg = c.yellow })

    -- Syntax
    hl("Comment",    { fg = c.ink_muted, italic = true })
    hl("Constant",   { fg = c.blue })
    hl("String",     { fg = c.green })
    hl("Character",  { fg = c.green })
    hl("Number",     { fg = c.blue })
    hl("Boolean",    { fg = c.blue, bold = true })
    hl("Identifier", { fg = c.ink })
    hl("Function",   { fg = c.cyan, bold = true })
    hl("Statement",  { fg = c.magenta, bold = true })
    hl("Conditional",{ fg = c.magenta })
    hl("Repeat",     { fg = c.magenta })
    hl("Keyword",    { fg = c.magenta, bold = true })
    hl("Operator",   { fg = c.ink_muted })
    hl("PreProc",    { fg = c.yellow })
    hl("Include",    { fg = c.magenta })
    hl("Type",       { fg = c.yellow, bold = true })
    hl("StorageClass",{ fg = c.yellow })
    hl("Structure",  { fg = c.yellow })
    hl("Special",    { fg = c.cyan })
    hl("Underlined", { fg = c.blue, underline = true })
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
    hl("@function.builtin",  { fg = c.cyan, italic = true })
    hl("@keyword",           { link = "Keyword" })
    hl("@keyword.function",  { link = "Keyword" })
    hl("@keyword.return",    { link = "Keyword" })
    hl("@conditional",       { link = "Conditional" })
    hl("@repeat",            { link = "Repeat" })
    hl("@type",              { link = "Type" })
    hl("@type.builtin",      { fg = c.yellow, italic = true })
    hl("@constant",          { link = "Constant" })
    hl("@constant.builtin",  { fg = c.blue, bold = true })
    hl("@variable",          { fg = c.ink })
    hl("@variable.builtin",  { fg = c.cyan, italic = true })
    hl("@parameter",         { fg = c.ink, italic = true })
    hl("@property",          { fg = c.cyan })
    hl("@field",              { fg = c.cyan })
    hl("@constructor",       { fg = c.yellow, bold = true })
    hl("@tag",               { fg = c.red })
    hl("@tag.attribute",     { fg = c.yellow })
    hl("@tag.delimiter",     { fg = c.ink_muted })
    hl("@punctuation.delimiter", { fg = c.ink_muted })
    hl("@punctuation.bracket",   { fg = c.ink_muted })
    hl("@operator",          { link = "Operator" })
    hl("@namespace",         { fg = c.yellow })
    hl("@include",           { link = "Include" })
    hl("@preproc",           { link = "PreProc" })
  '';
}
