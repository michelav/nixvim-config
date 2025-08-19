{ pkgs, ... }:
{
  imports = [
    ./core.nix
    ./workflow.nix
    ./ui.nix
  ];

  # Import all your configuration modules here
  viAlias = true;
  vimAlias = true;
  withNodeJs = true;

  clipboard = {
    providers.wl-copy.enable = true;
    register = "unnamedplus";
  };

  opts = {
    number = true;
    relativenumber = true;
    termguicolors = true;
    fileencoding = "utf-8";
    expandtab = true;
    tabstop = 2;
    softtabstop = 2;
    shiftwidth = 2;
    signcolumn = "yes";
    autoindent = true;
    smartindent = false;
    cursorline = true;
    list = true;
    listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣',eol = '↴' }";
  };

  globals = {
    mapleader = " ";
  };

  autoCmd = [
    {
      event = [ "Filetype" ];
      pattern = [
        "java"
        "c"
        "cpp"
        "bash"
        "sh"
      ];
      callback = {
        __raw = "function() set_indent(4, false) end";
      };
    }
    {
      event = [ "Filetype" ];
      pattern = [
        "make"
        "go"
      ];
      callback = {
        __raw = "function() set_indent(4, true) end";
      };
    }
    {
      event = [ "BufEnter" ];
      callback = {
        __raw = ''
          function()
                  if vim.bo.indentexpr == "" then
                    vim.opt_local.smartindent = true
                  end
                end'';
      };
    }
  ];

  extraConfigLua = ''
    local function set_indent(sw, use_tabs)
      vim.opt_local.expandtab   = not use_tabs
      vim.opt_local.shiftwidth  = sw
      vim.opt_local.tabstop     = sw
      vim.opt_local.softtabstop = use_tabs and 0 or sw
    end
  '';
  extraPackages = [ pkgs.nixfmt-tree ];
}
