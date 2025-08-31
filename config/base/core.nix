{
  lsp = {
    inlayHints.enable = true;
    servers = {
      ts_ls.enable = true;
      biome.enable = true;
      nixd.enable = true;
    };
  };
  plugins = {
    treesitter.enable = true;
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          typescript = [ "prettier" ];
          nix = [ "nixfmt" ];
          javascript = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            timeout_ms = 2000;
            stop_after_first = true;
          };
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
            vim.snippet.expand(args.body)
          end
        '';
        mapping.__raw = ''
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
