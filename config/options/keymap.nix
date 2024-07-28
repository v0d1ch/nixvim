{self, ...}: {
  keymaps = [
    {
      mode = "i";
      key = "jk";
      action = "<Esc>";
      options = {
        desc = "jk to escape";
      };
    }
    {
      mode = "n";
      key = "<leader>g";
      action = "<cmd>Neogit<cr>";
      options = {
        desc = "Open Neogit";
      };
    }
    {
      mode = "n";
      key = "<leader>n";
      action = "<cmd>:Oil<cr>";
      options = {
        desc = "Oil toggle";
      };
    }

  ];

  extraConfigVim = ''
          function! FormatCode()
             let save_pos = getpos(".")
             :execute '%!fourmolu -q %'
             call setpos(".", save_pos)
          endfunction

          augroup RunCommandOnWrite
             autocmd BufWritePost *.hs :call FormatCode()
          augroup END
  '';

}
