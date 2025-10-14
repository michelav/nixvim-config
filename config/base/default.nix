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
    showtabline = 0;
    expandtab = true;
    tabstop = 2;
    softtabstop = 2;
    shiftwidth = 2;
    signcolumn = "yes";
    autoindent = true;
    smartindent = false;
    cursorline = true;
    hlsearch = true;
    incsearch = true;
    ignorecase = true;
    scrolloff = 12;
    exrc = true;
    list = true;
    listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣', eol = '↴'}";
    splitbelow = true;
    wrap = false;
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
    -- === Soft-wrap friendly editing for documents ===
    local opt = vim.opt

    -- Define a setup function so we can reuse it for specific filetypes
    local function enable_softwrap()
      opt.wrap = true
      opt.linebreak = true           -- wrap at word boundaries
      opt.breakindent = true         -- maintain indent in wrapped lines
      opt.showbreak = "↳ "           -- prefix for wrapped segments
      opt.textwidth = 0              -- disable hard-wrap
      opt.formatoptions:remove({ "t" })  -- don't insert hard breaks while typing
      opt.scrolloff = 3              -- keep context visible

      -- Wrap-aware motions
      for _, mode in ipairs({ "n", "x", "o" }) do
        vim.keymap.set(mode, "j", function()
          return vim.v.count == 0 and "gj" or "j"
        end, { expr = true, silent = true, buffer = true, desc = "Down (wrap-aware)" })

        vim.keymap.set(mode, "k", function()
          return vim.v.count == 0 and "gk" or "k"
        end, { expr = true, silent = true, buffer = true, desc = "Up (wrap-aware)" })

        vim.keymap.set(mode, "0", function()
          return vim.v.count == 0 and "g0" or "0"
        end, { expr = true, silent = true, buffer = true })

        vim.keymap.set(mode, "$", function()
          return vim.v.count == 0 and "g$" or "$"
        end, { expr = true, silent = true, buffer = true })

        vim.keymap.set(mode, "^", function()
          return vim.v.count == 0 and "g^" or "^"
        end, { expr = true, silent = true, buffer = true })
      end

      -- Allow crossing screen lines with arrows and h/l
      opt.whichwrap:append("<,>,h,l,[,]")
    end

    -- Automatically enable soft-wrap for writing filetypes
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "tex", "html", "rst", "typst" },
      callback = enable_softwrap,
      desc = "Enable soft wrapping for academic/web documents",
    })

    -- Global toggle command
    vim.api.nvim_create_user_command("ToggleWrap", function()
      opt.wrap = not opt.wrap:get()
      vim.notify("Wrap: " .. (opt.wrap:get() and "enabled" or "disabled"))
    end, { desc = "Toggle soft wrapping" })

    local function set_indent(sw, use_tabs)
      vim.opt_local.expandtab   = not use_tabs
      vim.opt_local.shiftwidth  = sw
      vim.opt_local.tabstop     = sw
      vim.opt_local.softtabstop = use_tabs and 0 or sw
    end
  '';
  extraPackages = [ pkgs.nixfmt-tree ];
}
