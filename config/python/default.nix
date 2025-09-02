{
  lsp.servers = {
    basedpyright.enable = true;
  };
  plugins = {
    conform-nvim.settings = {
      formatters_by_ft = {
        "python" = [ "ruff" ];
      };
    };
    lint.lintersByFt = {
      python = [ "ruff" ];
    };
    dap-python.enable = true;
  };
}
