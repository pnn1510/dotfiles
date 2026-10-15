return {
  {
    "nvim-mini/mini.surround",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
    {
      "saghen/blink.cmp",
      version = not vim.g.lazyvim_blink_main and "*",
      build = vim.g.lazyvim_blink_main and "cargo build --release",
      opts_extend = {
        "sources.completion.enabled_providers",
        "sources.compat",
        "sources.default",
      },
      dependencies = {
        "rafamadriz/friendly-snippets",
        -- add blink.compat to dependencies
        {
          "saghen/blink.compat",
          optional = true, -- make optional so it's only enabled if any extras need it
          opts = {},
          version = not vim.g.lazyvim_blink_main and "*",
        },
      },
      event = { "InsertEnter", "CmdlineEnter" },

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        snippets = {
          preset = "default",
        },

        appearance = {
          -- sets the fallback highlight groups to nvim-cmp's highlight groups
          -- useful for when your theme doesn't support blink.cmp
          -- will be removed in a future release, assuming themes add support
          use_nvim_cmp_as_default = false,
          -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- adjusts spacing to ensure icons are aligned
          nerd_font_variant = "mono",
        },

        completion = {
          accept = {
            -- experimental auto-brackets support
            auto_brackets = {
              enabled = true,
            },
          },
          menu = {
            draw = {
              treesitter = { "lsp" },
            },
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
          },
          ghost_text = {
            enabled = vim.g.ai_cmp,
          },
        },

        -- experimental signature help support
        -- signature = { enabled = true },

        sources = {
          -- adding any nvim-cmp sources here will enable them
          -- with blink.compat
          compat = {},
          default = { "lsp", "path", "snippets", "buffer" },
        },

        cmdline = {
          enabled = true,
          keymap = {
            preset = "cmdline",
            ["<Right>"] = false,
            ["<Left>"] = false,
          },
          completion = {
            list = { selection = { preselect = false } },
            menu = {
              auto_show = function(ctx)
                return vim.fn.getcmdtype() == ":"
              end,
            },
            ghost_text = { enabled = true },
          },
        },

        keymap = {
          preset = "enter",
          ["<C-y>"] = { "select_and_accept" },
        },
      },
      ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
      config = function(_, opts)
        if opts.snippets and opts.snippets.preset == "default" then
          opts.snippets.expand = LazyVim.cmp.expand
        end
        -- setup compat sources
        local enabled = opts.sources.default
        for _, source in ipairs(opts.sources.compat or {}) do
          opts.sources.providers[source] = vim.tbl_deep_extend(
            "force",
            { name = source, module = "blink.compat.source" },
            opts.sources.providers[source] or {}
          )
          if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
            table.insert(enabled, source)
          end
        end

        -- add ai_accept to <Tab> key
        if not opts.keymap["<Tab>"] then
          if opts.keymap.preset == "super-tab" then -- super-tab
            opts.keymap["<Tab>"] = {
              require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
              LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }),
              "fallback",
            }
          else -- other presets
            opts.keymap["<Tab>"] = {
              LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }),
              "fallback",
            }
          end
        end

        -- Unset custom prop to pass blink.cmp validation
        opts.sources.compat = nil

        -- check if we need to override symbol kinds
        for _, provider in pairs(opts.sources.providers or {}) do
          ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
          if provider.kind then
            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            local kind_idx = #CompletionItemKind + 1

            CompletionItemKind[kind_idx] = provider.kind
            ---@diagnostic disable-next-line: no-unknown
            CompletionItemKind[provider.kind] = kind_idx

            ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
            local transform_items = provider.transform_items
            ---@param ctx blink.cmp.Context
            ---@param items blink.cmp.CompletionItem[]
            provider.transform_items = function(ctx, items)
              items = transform_items and transform_items(ctx, items) or items
              for _, item in ipairs(items) do
                item.kind = kind_idx or item.kind
                item.kind_icon = LazyVim.config.icons.kinds[item.kind_name] or item.kind_icon or nil
              end
              return items
            end

            -- Unset custom prop to pass blink.cmp validation
            provider.kind = nil
          end
        end

        require("blink.cmp").setup(opts)
      end,
    },
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   version = false, -- last release is way too old
  --   event = { "InsertEnter", "CmdlineEnter" },
  --   dependencies = {
  --     "hrsh7th/cmp-emoji",
  --     "hrsh7th/cmp-cmdline",
  --     "hrsh7th/cmp-nvim-lsp",
  --     "hrsh7th/cmp-buffer",
  --     "hrsh7th/cmp-path",
  --   },
  --   ---@param opts cmp.ConfigSchema
  --   opts = function(_, opts)
  --     table.insert(opts.sources, { name = "emoji" })
  --     -- Register nvim-cmp lsp capabilities
  --     vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
  --
  --     vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
  --     local cmp = require("cmp")
  --     -- Setup completion for search mode '/'
  --     cmp.setup.cmdline("/", {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = {
  --         { name = "buffer" },
  --       },
  --     })
  --
  --     -- Setup completion for command mode ':'
  --     cmp.setup.cmdline(":", {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = cmp.config.sources({
  --         { name = "path" },
  --       }, {
  --         {
  --           name = "cmdline",
  --           option = {
  --             ignore_cmds = { "Man", "!" },
  --           },
  --         },
  --       }),
  --     })
  --     local defaults = require("cmp.config.default")()
  --     local auto_select = true
  --     return {
  --       auto_brackets = {}, -- configure any filetype to auto add brackets
  --       completion = {
  --         completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
  --       },
  --       preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
  --       mapping = cmp.mapping.preset.insert({
  --         ["<C-b>"] = cmp.mapping.scroll_docs(-4),
  --         ["<C-f>"] = cmp.mapping.scroll_docs(4),
  --         ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
  --         ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  --         ["<C-Space>"] = cmp.mapping.complete(),
  --         ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
  --         ["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
  --         ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  --         ["<C-CR>"] = function(fallback)
  --           cmp.abort()
  --           fallback()
  --         end,
  --         ["<tab>"] = function(fallback)
  --           return LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }, fallback)()
  --         end,
  --       }),
  --       sources = cmp.config.sources({
  --         { name = "lazydev" },
  --         { name = "nvim_lsp" },
  --         { name = "path" },
  --       }, {
  --         { name = "buffer" },
  --       }),
  --       formatting = {
  --         format = function(entry, item)
  --           local icons = LazyVim.config.icons.kinds
  --           if icons[item.kind] then
  --             item.kind = icons[item.kind] .. item.kind
  --           end
  --
  --           local widths = {
  --             abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
  --             menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
  --           }
  --
  --           for key, width in pairs(widths) do
  --             if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
  --               item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
  --             end
  --           end
  --
  --           return item
  --         end,
  --       },
  --       experimental = {
  --         -- only show ghost text when we show ai completions
  --         ghost_text = vim.g.ai_cmp and {
  --           hl_group = "CmpGhostText",
  --         } or false,
  --       },
  --       sorting = defaults.sorting,
  --     }
  --   end,
  -- },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },
}
