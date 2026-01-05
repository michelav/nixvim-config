{ lib, ... }:
{
  lsp = {
    inlayHints.enable = true;
    servers = {
      nixd.enable = true;
      biome.enable = true;
      just.enable = true;
    };
    keymaps = [
      {
        key = "gd";
        lspBufAction = "definition";
        options.desc = "Go to the definition";
      }
      {
        key = "gD";
        lspBufAction = "declaration";
        options.desc = "Go to the declaration";
      }
      {
        key = "gr";
        lspBufAction = "references";
        options.desc = "Go to the references";
      }
      {
        key = "gt";
        lspBufAction = "type_definition";
        options.desc = "Go to the type definition";
      }
      {
        key = "gi";
        lspBufAction = "implementation";
        options.desc = "Go to the implementation";
      }
      {
        key = "K";
        action = "<CMD>Lspsaga hover_doc<Enter>";
        options.desc = "Documentation hover";
      }
      {
        action = lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count=-1, float=true }) end";
        key = "[d";
        options.desc = "Previous diagnostic item";
      }
      {
        action = lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count=1, float=true }) end";
        key = "]d";
        options.desc = "Next diagnostic item";
      }
      {
        action = "<CMD>LspStop<Enter>";
        key = "<leader>lx";
      }
      {
        action = "<CMD>LspStart<Enter>";
        key = "<leader>ls";
      }
      {
        action = "<CMD>LspRestart<Enter>";
        key = "<leader>lr";
      }
      {
        action = "<CMD>Lspsaga outline<Enter>";
        key = "<leader>o";
        options.desc = "Saga outline";
      }
      {
        action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_definitions";
        key = "gd";
      }
    ];
  };
  plugins = {
    which-key.enable = true;
    dap.enable = true;
    dap-ui.enable = true;
    treesitter = {
      enable = true;
      settings.highlight.enable = true;
    };
    # FIXME: Re-enable when textobjects are fixed
    # treesitter-textobjects.enable = true;
    hmts.enable = true; # Home Manager Treesitter queries
    ledger.enable = true;
    lint = {
      enable = true;
      lintersByFt = {
        nix = [ "nix" ];
      };
    };
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          json = [ "biome" ];
        };
        format_on_save = {
          lsp_format = "fallback";
          timeout_ms = 500;
        };
      };
    };
    lsp = {
      enable = true;
      inlayHints = true;
    };
    lspsaga = {
      enable = true;
      settings = {
        outline = {
          enable = true;
          auto_close = true;
          close_after_jump = true;
        };
      };
    };
    # Snippets
    friendly-snippets.enable = true;
    luasnip = {
      enable = true;
      fromVscode = [ { } ];
      fromLua = [
        { }
        {
          paths.__raw = "vim.fn.getcwd() .. '/.luasnippets'";
        }
      ];
    };
    cmp_luasnip.enable = true;
    cmp = {
      enable = true;
      autoEnableSources = true;
      cmdline = {
        "/" = {
          mapping = {
            __raw = "cmp.mapping.preset.cmdline()";
          };
          sources = [
            {
              name = "buffer";
            }
            { name = "nvim_lsp_document_symbol"; }
            { name = "cmdline"; }
          ];
        };
        ":" = {
          mapping = {
            __raw = "cmp.mapping.preset.cmdline()";
          };
          sources = [
            {
              name = "path";
            }
            {
              name = "cmdline";
              option = {
                ignore_cmds = [
                  "Man"
                  "!"
                ];
              };
            }
          ];
        };
      };
      luaConfig.pre = "local luasnip = require('luasnip')";
      settings = {
        completion.autocomplete = [ "require('cmp.types').cmp.TriggerEvent.TextChanged" ];
        window = {
          completion = {
            border = "rounded";
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
          };
          documentation.__raw = "cmp.config.window.bordered()";
        };
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
          { name = "buffer"; }
          { name = "nvim_lua"; }
          { name = "treesitter"; }
          { name = "path"; }
          { name = "buffer"; }
          { name = "nvim_lsp_signature_help"; }
          { name = "conventionalcommits"; }
        ];
        snippet.expand.__raw = ''
          function(args)
            luasnip.lsp_expand(args.body)
          end
        '';
        mapping.__raw = # Lua
          ''
            cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    if luasnip.expandable() then
                        luasnip.expand()
                    else
                        cmp.confirm({
                            select = true,
                        })
                    end
                else
                    fallback()
                end
              end),
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.locally_jumpable(1) then
                  luasnip.jump(1)
                else
                  fallback()
                end
              end, { "i", "s" }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" }),
            })
          '';
      };
    };
  };
}
