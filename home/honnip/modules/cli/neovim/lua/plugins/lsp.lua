return {
  {
    name = "nvim-lspconfig",
    dir = "@nvim_lspconfig@",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lspconfig = require('lspconfig')
      -- keymap
      -- 나중에

      local servers = {
        -- html
        html = { },

        -- css
        cssls = { },

        -- python
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
              }
            }
          }
        },

        -- rust
        rust_analyzer = {
          settings = {
            ['rust-analyzer'] = {
              checkOnSave = {
                command = "clippy"
              }
            }
          }
        },

        -- lua
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              completion = {
                callSnippet = "Replace",
              },
              runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
              workspace = {
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
                maxPreload = 4096, -- default 300;
                preloadFileSize = 1024, -- default 100;
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },

	-- nix
	nixd = { },

        -- deno
        denols = {
          root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
        },

        -- svelte
        svelte = { },

        -- toml
        taplo = { },
      }

      vim.diagnostic.config({
        virtual_text = {
          spacing = 4,
          prefix = "~"
        },
        signs = true,
        underline = true,
        update_in_insert = true,
        severity_sort = false
      })

      for server, config in pairs(servers) do
        if type(config) == "function" then
          config()
        else
          lspconfig[server].setup(config)
        end
      end
    end
  }
}
