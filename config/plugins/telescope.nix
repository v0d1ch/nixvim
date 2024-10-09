{
  plugins.telescope = {
    enable = true;
    extensions = {
      file-browser = {
        enable = true;
      };
      fzf-native = {
        enable = true;
      };
      live-grep-args = {
        enable = true;
      };
    };
    settings = {
      defaults = {
        layout_config = {
          horizontal = {
            prompt_position = "top";
          };
        };
        sorting_strategy = "ascending";
      };
    };
    keymaps = {
      "<leader><space>" = {
        action = "find_files";
        options = {
          desc = "Find project files";
        };
      };
      "<leader>:" = {
        action = "command_history";
        options = {
          desc = "Command History";
        };
      };
      "<leader>ff" = {
        action = "find_files";
        options = {
          desc = "Find project files";
        };
      };
      "<leader>s" = {
        action = "live_grep";
        options = {
          desc = "Find text";
        };
      };
      "<leader>h" = {
        action = "live_grep_args";
        options = {
          desc = "Find text";
        };
      };
      "<leader>rs" = {
        action = "resume";
        options = {
          desc = "Resume";
        };
      };
     "<leader>b" = {
        action = "buffers";
        options = {
          desc = "+buffer";
        };
      };
      "<leader>k" = {
        action = "current_buffer_fuzzy_find";
        options = {
          desc = "Buffer";
        };
      };
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>fe";
      action = "<cmd>Telescope file_browser<cr>";
      options = {
        desc = "File browser";
      };
    }
    {
      mode = "n";
      key = "<leader>fE";
      action = "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>";
      options = {
        desc = "File browser";
      };
    }
  ];
  extraConfigLua = ''
    require("telescope").setup{
      pickers = {
        buffers = {
          sort_lastused = true,
          ignore_current_buffer = true,
        },
        colorscheme = {
          enable_preview = true
        }
      }
    }
  '';
}
