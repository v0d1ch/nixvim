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
    {
      mode = "n";          # Normal mode
      key = "*";           # The key to map
      action = "*``";      # Perform * then jump back
      options = {
        silent = true;     # Optional: suppress messages (common for this mapping)
        noremap = true;    # Ensures non-recursive mapping (default in Nixvim for safety)
        desc = "Search word under cursor forward and return to position";  # Optional: description for which-key or docs
      };
    }
    {
      mode = "x";
      key = "<leader>hh";
      action.__raw = ''function() Hoogle.visual() end'';
      options = {
        desc = "Hoogle search selection";
      };
    }
  ];

  extraConfigLua = ''
    _G.Hoogle = {}

    Hoogle.url_encode = function(str)
      return (str:gsub('([^%w%-%._~])', function(c)
        return string.format('%%%02X', string.byte(c))
      end))
    end

    Hoogle.search = function(query)
      local q = vim.trim(query)
      if #q == 0 then return end
      local url = 'http://localhost:8080/?hoogle=' .. Hoogle.url_encode(q)
      vim.fn.jobstart({'xdg-open', url}, {detach = true})
    end

    Hoogle.visual = function()
      local vstart = vim.fn.getpos('v')
      local vend   = vim.fn.getpos('.')
      if vstart[2] > vend[2] or (vstart[2] == vend[2] and vstart[3] > vend[3]) then
        vstart, vend = vend, vstart
      end
      local lines = vim.api.nvim_buf_get_lines(0, vstart[2] - 1, vend[2], false)
      if #lines == 0 then return end
      lines[#lines] = lines[#lines]:sub(1, vend[3])
      lines[1]      = lines[1]:sub(vstart[3])
      Hoogle.search(table.concat(lines, ' '))
    end

    vim.api.nvim_create_user_command('Hoo', function(opts)
      Hoogle.search(opts.args)
    end, { nargs = '+', desc = 'Search local Hoogle' })
  '';

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
