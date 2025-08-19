{
  diagnostic.settings = {
    update_in_insert = true;
    virtual_lines = {
      current_line = true;
    };
    virtual_text = {
      severity.__raw = "vim.diagnostic.severity.WARN";
      source = "always";
      spacing = 5;
    };
  };
  colorschemes.base16 = {
    enable = true;
    colorscheme = "nord";
  };
  plugins = {
    indent-blankline.enable = true;
    lualine.enable = true;
  };
}
