_: {
  lsp = {
    inlayHints.enable = true;
    servers = {
      ts_ls.enable = true;
      biome.enable = true;
    };
  };
  plugins = {
    conform-nvim = {
      settings = {
        formatters_by_ft = {
          typescript = [ "prettier" ];
          javascript = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            timeout_ms = 2000;
            stop_after_first = true;
          };
        };
      };
    };
  };
}
