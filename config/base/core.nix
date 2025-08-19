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
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "nvim_lua"; }
        { name = "treesitter"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "luasnip"; }
        { name = "nvim_lsp_signature_help"; }
      ];
    };
  };
}
