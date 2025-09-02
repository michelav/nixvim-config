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
    lspkind.enable = true;
    dropbar.enable = true;
    lualine = {
      enable = true;
      settings = {
        sections.lualine_c.__raw = ''
          {
            { "%=", separator = "" },
            {
              "filename",
              cond = function() return vim.fn.empty(vim.fn.expand("%:t")) ~= 1 end,
              filestatus = true,
              path = 3,
              symbols = {
                modified = "[+]", -- Text to show when the file is modified.
                readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
                unnamed = "[No Name]", -- Text to show for unnamed buffers.
                newfile = "[New]", -- Text to show for newly created file before first write
              },
              separator = "",
            },
          }
        '';
      };
    };
  };
}
