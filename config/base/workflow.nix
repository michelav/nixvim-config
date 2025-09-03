{
  plugins = {
    oil.enable = true;
    trouble.enable = true;
    web-devicons.enable = true;
    fugitive.enable = true;
    gitsigns.enable = true;
    nvim-tree = {
      enable = true;
      autoClose = true;
      settings = {
        actions.open_file.quit_on_open = true;
      };
    };
    nvim-autopairs = {
      enable = true;
      settings = {
        disable_filetype = [ "TelescopePrompt" ];
        check_ts = true;
      };
    };
    nvim-surround.enable = true;
    telescope = {
      enable = true;
      settings = {
        defaults = {
          prompt_prefix = "     ";
          layout_config = {
            horizontal = {
              prompt_position = "top";
              preview_width = 0.55;
              results_width = 0.8;
            };
            vertical = {
              mirror = false;
            };
            width = 0.8;
            height = 0.8;
            preview_cutoff = 120;
          };
          borderchars.__raw = "{ '─', '│', '─', '│', '╭', '╮', '╯', '╰' }";
        };
      };
    };
  };
  keymaps = [
    {
      action = ":NvimTreeFindFileToggle<cr>";
      key = "<leader>e";
      mode = [ "n" ];
    }

    # Telescope
    {
      action = ":Telescope find_files<cr>";
      key = "<leader>ff";
      mode = [ "n" ];
    }
    {
      action = ":Telescope live_grep<cr>";
      key = "<leader>fg";
      mode = [ "n" ];
    }
    {
      action = ":Telescope buffers<cr>";
      key = "<leader>fb";
      mode = [ "n" ];
    }
    {
      action = ":Telescope git_files<cr>";
      key = "<leader>fs";
      mode = [ "n" ];
    }
    {
      action = ":bd<cr>";
      key = "<leader>q";
      mode = [ "n" ];
    }
    {
      action = ":bp<cr>";
      key = "<leader>[";
      mode = [ "n" ];
    }
    {
      action = ":bn<cr>";
      key = "<leader>]";
      mode = [ "n" ];
    }
  ];
}
