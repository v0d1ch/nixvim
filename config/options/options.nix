{self, ...}: {
  opts = {
    # Line numbers
    number = true;
    relativenumber = true;

    encoding = "utf-8";

    autoread = true;

    # Always show the signcolumn, otherwise text would be shifted when displaying error icons
    signcolumn = "yes";
    foldcolumn = "0";

    # Search
    ignorecase = true;
    smartcase = true;
    wrapscan = false;

    swapfile = false;

    # Tab defaults (might get overwritten by an LSP server)
    tabstop = 4;
    shiftwidth = 4;
    softtabstop = 0;
    expandtab = true;
    smarttab = true;
    termguicolors = true;

    # System clipboard support, needs xclip/wl-clipboard
    clipboard = "unnamedplus";

    # Highlight the current line
    cursorline = true;

    # Show line and column when searching
    ruler = true;

    # Global substitution by default
    gdefault = true;

    # Start scrolling when the cursor is X lines away from the top/bottom
    scrolloff = 5;

    conceallevel = 2;
  };

  userCommands = {
    Q.command = "q";
    Q.bang = true;
    Wq.command = "q";
    Wq.bang = true;
    WQ.command = "q";
    WQ.bang = true;
    W.command = "q";
    W.bang = true;
  };

  globals.mapleader = " ";

  # Route the system clipboard through OSC 52 only when the Wayland socket is
  # unreachable (Herdr panes export a stale $WAYLAND_DISPLAY; also covers SSH).
  # When the socket is reachable, vim.g.clipboard stays unset and Neovim uses
  # its normal wl-copy/xclip provider, so other terminals are unaffected.
  extraConfigLua = /* lua */ ''
    local rt, wl = vim.env.XDG_RUNTIME_DIR, vim.env.WAYLAND_DISPLAY
    local wayland_ok = rt and wl and vim.uv.fs_stat(rt .. "/" .. wl) ~= nil
    if not wayland_ok then
      local osc52 = require("vim.ui.clipboard.osc52")
      vim.g.clipboard = {
        name = "OSC 52",
        copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
        paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
      }
    end
  '';

}
