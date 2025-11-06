_: {

  autoCmd = [
    {
      desc = "Organize imports when saving";
      pattern = [
        "*.ts"
        "*.tsx"
        "*.js"
        "*.jsx"
      ];
      event = [ "BufWritePre" ];
      callback = {
        __raw = # Lua
          ''
            function(args)
              local bufnr = args.bufnr
              local enc = "utf-16"
              local clients = vim.lsp.get_clients({bufnr = bufnr, name = "ts_ls"})
              local client = clients[1]
              local params = vim.lsp.util.make_range_params(0, enc) -- ts_ls uses utf16
              params.context = { only = { "source.addMissingImports.ts" }, diagnostics = {}, }
                   -- Request only from the chosen client to avoid mixed encodings
              client.request("textDocument/codeAction", params,
              function(err, res, ctx)
                for _, action in ipairs(res) do
                  if action.edit then
                    vim.lsp.util.apply_workspace_edit(action.edit, enc)
                  end
                  if action.command then
                    vim.lsp.buf.execute_command(action.command)
                  end
                end
              end,
              bufnr)
            end
          '';
      };
    }
  ];

  lsp = {
    inlayHints.enable = true;
    servers = {
      ts_ls.enable = true;
    };
  };
  plugins = {
    conform-nvim = {
      settings = {
        formatters_by_ft = {
          typescript = [ "biome-check" ];
          javascript = {
            __unkeyed-1 = "biome-check";
            __unkeyed-2 = "biome-check";
            timeout_ms = 2000;
            stop_after_first = true;
          };
          typescriptreact = [ "biome-check" ];
          javascriptreact = [ "biome-check" ];
        };
      };
    };
  };
}
