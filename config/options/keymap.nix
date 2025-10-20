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
      key = "<leader>gg";
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
    {
      mode = "n";
      key = "<leader>x";
      action = "<cmd>:call Scratch()<cr>";
      options = {
        desc = "Scratch buffer";
      };
    }
    {
      mode = "x";
      key = "<leader>p";
      action = "\"_dP";
      options = {
        desc = "Smart paste";
      };
    }
  ];

  extraConfigVim = ''
          function! FormatCode()
             let save_pos = getpos(".")
             :execute '%!fourmolu -q %'
             call setpos(".", save_pos)
          endfunction



          function! Scratch()
              let scratch_buf = bufnr('scratch')
              if scratch_buf == -1
                  noswapfile hide enew
                  setlocal buftype=nofile
                  setlocal bufhidden=hide
                  file scratch
              else
                  let scratch_win = bufwinnr(scratch_buf)
                  if scratch_win == -1
                      execute 'buffer ' . scratch_buf
                  else
                      execute scratch_win . 'wincmd w'
                  endif
              endif
          endfunction
  '';

}
