{
  lsp = {
    inlayHints.enable = true;
    servers = {
      nixd.enable = true;
    };
  };
  plugins = {
    dap.enable = true;
    dap-ui.enable = true;
    treesitter = {
      enable = true;
      settings.highlight.enable = true;
    };
    treesitter-textobjects.enable = true;
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
      settings = {
        completion.autocomplete = [ "require('cmp.types').cmp.TriggerEvent.TextChanged" ];
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
            require('luasnip').lsp_expand(args.body)
          end
        '';
        mapping.__raw = # Lua
          ''
            cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
            })
          '';
      };
    };
  };
}
