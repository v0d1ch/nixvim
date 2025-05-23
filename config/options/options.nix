{self, ...}: {
  globalOpts = {
    # Line numbers
    # number = true;
    relativenumber = true;

    encoding = "utf-8";

    autoread = true;

    # Always show the signcolumn, otherwise text would be shifted when displaying error icons
    signcolumn = "no";
    foldcolumn = "0";

    # Search
    ignorecase = true;
    smartcase = true;

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

}
