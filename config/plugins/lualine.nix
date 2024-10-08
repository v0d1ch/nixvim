{ icons, ... }:
let
  themeColors = {
    bg = "none";
    fg = "#d2d2d2";
    yellow = "#ECBE7B";
    cyan = "#008080";
    darkblue = "#081633";
    green = "#98be65";
    orange = "#FF8800";
    violet = "#a9a1e1";
    magenta = "#c678dd";
    blue = "#51afef";
    red = "#ec5f67";
  };
  colors = themeColors // {
    bg = "#202328";
    fg = "#bbc2cf";
  };
in 
{
  plugins.lualine = {
    enable = true;
    settings.options = {
       always_divide_middle = true;
       icons_enabled = true;
       theme = {
              normal = {
                a = {
                  fg = themeColors.bg;
                  bg = themeColors.blue;
                  gui = "bold";
                };
                b = {
                  inherit (themeColors) fg;
                  bg = themeColors.darkblue;
                };
                c = {
                  inherit (themeColors) fg;
                  inherit (themeColors) bg;
                };
              };
              insert = {
                a = {
                  fg = themeColors.bg;
                  bg = themeColors.green;
                  gui = "bold";
                };
                b = {
                  inherit (themeColors) fg;
                  bg = themeColors.darkblue;
                };
                c = {
                  inherit (themeColors) fg;
                  inherit (themeColors) bg;
                };
              };
              visual = {
                a = {
                  fg = themeColors.bg;
                  bg = themeColors.magenta;
                  gui = "bold";
                };
                b = {
                  inherit (themeColors) fg;
                  bg = themeColors.darkblue;
                };
                c = {
                  inherit (themeColors) fg;
                  inherit (themeColors) bg;
                };
              };
              replace = {
                a = {
                  fg = themeColors.bg;
                  bg = themeColors.red;
                  gui = "bold";
                };
                b = {
                  inherit (themeColors) fg;
                  bg = themeColors.darkblue;
                };
                c = {
                  inherit (themeColors) fg;
                  inherit (themeColors) bg;
                };
              };
              command = {
                a = {
                  fg = themeColors.bg;
                  bg = themeColors.orange;
                  gui = "bold";
                };
                b = {
                  inherit (themeColors) fg;
                  bg = themeColors.darkblue;
                };
                c = {
                  inherit (themeColors) fg;
                  inherit (themeColors) bg;
                };
              };
              inactive = {
                a = {
                  inherit (themeColors) fg;
                  inherit (themeColors) bg;
                  gui = "bold";
                };
                b = {
                  inherit (themeColors) fg;
                  inherit (themeColors) bg;
                };
                c = {
                  inherit (themeColors) fg;
                  inherit (themeColors) bg;
                };
              };
            };
    };
    
  };

extraConfigLua = ''
      local function diff_source()
      ---@diagnostic disable-next-line: undefined-field
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
        return {
          added = gitsigns.added,
          modified = gitsigns.changed,
          removed = gitsigns.removed,
        }
      end
    end

    local components = {}

    components.mode = {
      "mode",
      color = function()
        -- auto change color according to neovims mode{{{
        local mode_color = {
          n = "${colors.green}",
          i = "${colors.blue}",
          v = "${colors.magenta}",
          [""] = "${colors.magenta}",
          V = "${colors.magenta}",
          c = "${colors.red}",
          no = "${colors.red}",
          s = "${colors.orange}",
          S = "${colors.orange}",
          [""] = "${colors.orange}",
          ic = "${colors.yellow}",
          R = "${colors.violet}",
          Rv = "${colors.violet}",
          cv = "${colors.red}",
          ce = "${colors.red}",
          r = "${colors.cyan}",
          rm = "${colors.cyan}",
          ["r?"] = "${colors.cyan}",
          ["!"] = "${colors.red}",
          t = "${colors.red}",
        } -- }}}
        return { bg = mode_color[vim.fn.mode()], fg = "#000000" }
      end,
      fmt = function()
        return "${icons.kind.Function}"
      end,
    }


    components.branch = {
      "b:gitsigns_head",
      icon = "${icons.git.Branch}",
      color = { gui = "bold" },
    }
    components.diff = {
      "diff",
      source = diff_source,
      symbols = {
        added = "${icons.git.LineAdded}" .. " ",
        modified = "${icons.git.LineModified}" .. " ",
        removed = "${icons.git.LineRemoved}" .. " ",
      },
    }
    components.diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      symbols = {
        error = "${icons.diagnostics.BoldError}" .. " ",
        warn = "${icons.diagnostics.BoldWarning}" .. " ",
        info = "${icons.diagnostics.BoldInformation}" .. " ",
        hint = "${icons.diagnostics.BoldHint}" .. " ",
      },
    }
    components.filetype = { "filetype", cond = nil, padding = { left = 1, right = 1 } }
    components.fileformat = { "fileformat", cond = nil, padding = { left = 1, right = 1 }, color = "SLGreen" }

    components.lsp = {
      function()
        local clients = vim.lsp.get_active_clients()
        local names = {}

        if next(clients) == nil then
          return "Ls Inactive"
        end
        for _, client in ipairs(clients) do
          if client.name ~= "copilot" and client.name ~= "null-ls" then
            table.insert(names, client.name)
          end
        end

        local nok, null_ls = pcall(require, "null-ls")
        if not nok then
          return "[" .. table.concat(vim.fn.uniq(names), ", ") .. "]"
        end

        -- if using null-ls (Depricated now)
        local buf_ft = vim.bo.filetype

        local function registered_method(filetype)
          local sources = require("null-ls.sources")
          local available_sources = sources.get_available(filetype)
          local registered = {}

          for _, source in ipairs(available_sources) do
            for method in pairs(source.methods) do
              registered[method] = registered[method] or {}
              table.insert(registered[method], source.name)
            end
          end

          return registered or {}
        end

        local f = null_ls.methods.FORMATTING
        vim.list_extend(names, registered_method(buf_ft)[f])

        -- local d = null_ls.methods.DIAGNOSTICS
        local alternative_methods = {
          null_ls.methods.DIAGNOSTICS,
          null_ls.methods.DIAGNOSTICS_ON_OPEN,
          null_ls.methods.DIAGNOSTICS_ON_SAVE,
        }

        local registered_providers = registered_method(buf_ft)
        local providers_for_methods = vim.tbl_flatten(vim.tbl_map(function(m)
          return registered_providers[m] or {}
        end, alternative_methods))

        vim.list_extend(names, providers_for_methods)

        return "[" .. table.concat(vim.fn.uniq(names), ", ") .. "]"
      end,
    }

    components.indicator = function()
      local ok, noice = pcall(require, "noice")
      if not ok then
        return ""
      end
      return {
        noice.api.statusline.mode.get,
        cond = noice.api.statusline.mode.has,
        color = { fg = "#ff9e64" },
      }
    end

    components.copilot = function()
      local lsp_clients = vim.lsp.get_active_clients()
      local copilot_active = false
      local str = ""
      if next(lsp_clients) == nil then
        return str
      end

      for _, client in ipairs(lsp_clients) do
        if client.name == "copilot" then
          copilot_active = true
          break
        end
      end
      if copilot_active then
        str = "%#SLGreen#" .. "${icons.kind.Copilot}"
      end
      return str
    end

    components.location = {
      "location",
      color = { fg = "#ffffff", bg = "#000000" },
    }


    local sections = {
      lualine_a = { components.mode },
      lualine_b = { components.fileformat, "encoding" },
      lualine_c = { components.branch, components.diff },
      lualine_x = {
        components.indicator(),
        components.diagnostics,
        components.filetype,
        components.lsp,
      },
      lualine_y = { "progress" },
      lualine_z = { components.location, components.copilot },
    }
    local lualine = require("lualine")
    lualine.setup({
      options = {
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          "alpha",
          "dashboard",
          "NvimTree",
          "Outline",
          "neo-tree",
          "dashboard",
          "Alpha",
        },
      },
      sections = sections,
    })
 '';
}
# extraConfigLua = ''
#      -- Eviline config for lualine
#      -- Author: shadmansaleh
#      -- Credit: glepnir
#      local lualine = require("lualine")
#      
#      -- Color table for highlights
#      -- stylua: ignore
#      local colors = {
#        bg       = "#202328",
#        fg       = "#bbc2cf",
#        yellow   = "#ECBE7B",
#        cyan     = "#008080",
#        darkblue = "#081633",
#        green    = "#98be65",
#        orange   = "#FF8800",
#        violet   = "#a9a1e1",
#        magenta  = "#c678dd",
#        blue     = "#51afef",
#        red      = "#ec5f67",
#      }
#      
#      local conditions = {
#        buffer_not_empty = function()
#          return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
#        end,
#        hide_in_width = function()
#          return vim.fn.winwidth(0) > 80
#        end,
#        check_git_workspace = function()
#          local filepath = vim.fn.expand("%:p:h")
#          local gitdir = vim.fn.finddir(".git", filepath .. ";")
#          return gitdir and #gitdir > 0 and #gitdir < #filepath
#        end,
#      }
#      
#      -- Config
#      local config = {
#        options = {
#          -- Disable sections and component separators
#          component_separators = "",
#          section_separators = "",
#          theme = {
#            -- We are going to use lualine_c an lualine_x as left and
#            -- right section. Both are highlighted by c theme .  So we
#            -- are just setting default looks o statusline
#            normal = { c = { fg = colors.fg, bg = colors.bg } },
#            inactive = { c = { fg = colors.fg, bg = colors.bg } },
#          },
#        },
#        sections = {
#          -- these are to remove the defaults
#          lualine_a = {},
#          lualine_b = {},
#          lualine_y = {},
#          lualine_z = {},
#          -- These will be filled later
#          lualine_c = {},
#          lualine_x = {},
#        },
#        inactive_sections = {
#          -- these are to remove the defaults
#          lualine_a = {},
#          lualine_b = {},
#          lualine_y = {},
#          lualine_z = {},
#          lualine_c = {},
#          lualine_x = {},
#        },
#      }
#      
#      -- Inserts a component in lualine_c at left section
#      local function ins_left(component)
#        table.insert(config.sections.lualine_c, component)
#      end
#      
#      -- Inserts a component in lualine_x at right section
#      local function ins_right(component)
#        table.insert(config.sections.lualine_x, component)
#      end
#      
#      ins_left {
#        function()
#          return "▊"
#        end,
#        color = { fg = colors.blue }, -- Sets highlighting of component
#        padding = { left = 0, right = 1 }, -- We dont need space before this
#      }
#      
#      ins_left {
#        -- mode component
#        function()
#          return ""
#        end,
#        color = function()
#          -- auto change color according to neovims mode
#          local mode_color = {
#            n = colors.red,
#            i = colors.green,
#            v = colors.blue,
#            [""] = colors.blue,
#            V = colors.blue,
#            c = colors.magenta,
#            no = colors.red,
#            s = colors.orange,
#            S = colors.orange,
#            [""] = colors.orange,
#            ic = colors.yellow,
#            R = colors.violet,
#            Rv = colors.violet,
#            cv = colors.red,
#            ce = colors.red,
#            r = colors.cyan,
#            rm = colors.cyan,
#            ["r?"] = colors.cyan,
#            ["!"] = colors.red,
#            t = colors.red,
#          }
#          return { fg = mode_color[vim.fn.mode()] }
#        end,
#        padding = { right = 1 },
#      }
#      
#      ins_left {
#        -- filesize component
#        "filesize",
#        cond = conditions.buffer_not_empty,
#      }
#      
#      ins_left {
#        "filename",
#        cond = conditions.buffer_not_empty,
#        color = { fg = colors.magenta, gui = "bold" },
#      }
#      
#      ins_left { "location" }
#      
#      ins_left { "progress", color = { fg = colors.fg, gui = "bold" } }
#      
#      ins_left {
#        "diagnostics",
#        sources = { "nvim_diagnostic" },
#        symbols = { error = " ", warn = " ", info = " " },
#        diagnostics_color = {
#          error = { fg = colors.red },
#          warn = { fg = colors.yellow },
#          info = { fg = colors.cyan },
#        },
#      }
#      
#      -- Insert mid section. You can make any number of sections in neovim :)
#      -- for lualine its any number greater then 2
#      ins_left {
#        function()
#          return "%="
#        end,
#      }
#      
#      ins_left {
#        -- Lsp server name .
#        function()
#          local msg = "No Active Lsp"
#          local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
#          local clients = vim.lsp.get_active_clients()
#          if next(clients) == nil then
#            return msg
#          end
#          for _, client in ipairs(clients) do
#            local filetypes = client.config.filetypes
#            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
#              return client.name
#            end
#          end
#          return msg
#        end,
#        icon = " LSP:",
#        color = { fg = "#ffffff", gui = "bold" },
#      }
#      
#      -- Add components to right sections
#      ins_right {
#        "o:encoding", -- option component same as &encoding in viml
#        fmt = string.upper, -- Im not sure why its upper case either ;)
#        cond = conditions.hide_in_width,
#        color = { fg = colors.green, gui = "bold" },
#      }
#      
#      ins_right {
#        "fileformat",
#        fmt = string.upper,
#        icons_enabled = false, -- I think icons are cool but Eviline doesn"t have them. sigh
#        color = { fg = colors.green, gui = "bold" },
#      }
#      
#      ins_right {
#        "branch",
#        icon = "",
#        color = { fg = colors.violet, gui = "bold" },
#      }
#      
#      ins_right {
#        "diff",
#        -- Is it me or the symbol for modified us really weird
#        symbols = { added = " ", modified = "󰝤 ", removed = " " },
#        diff_color = {
#          added = { fg = colors.green },
#          modified = { fg = colors.orange },
#          removed = { fg = colors.red },
#        },
#        cond = conditions.hide_in_width,
#      }
#      
#      ins_right {
#        function()
#          return "▊"
#        end,
#        color = { fg = colors.blue },
#        padding = { left = 1 },
#      }
#      
#      -- Now dont forget to initialize lualine
#      lualine.setup(config)
#    '';


