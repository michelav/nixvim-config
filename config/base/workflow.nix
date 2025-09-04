{
  plugins = {
    oil.enable = true;
    trouble.enable = true;
    web-devicons.enable = true;
    fugitive.enable = true;
    gitsigns = {
      enable = true;
      settings = {
        current_line_blame = false;
        current_line_blame_opts = {
          virt_text = true;
          virt_text_pos = "eol";
        };
        on_attach.__raw = ''
          function(bufnr)
            local gs = package.loaded.gitsigns
            local map = function(mode, lhs, rhs, opts)
              opts = opts or {}; opts.buffer = bufnr
              vim.keymap.set(mode, lhs, rhs, opts)
            end

            -- Hunk nav
            map('n', ']h', function() if vim.wo.diff then return ']c' end gs.next_hunk() end, {expr=true})
            map('n', '[h', function() if vim.wo.diff then return '[c' end gs.prev_hunk() end, {expr=true})

            -- Stage / reset hunks
            map({'n','v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
            map({'n','v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
            map('n', '<leader>hS', gs.stage_buffer)
            map('n', '<leader>hu', gs.undo_stage_hunk)
            map('n', '<leader>hR', gs.reset_buffer)

            -- Inspect
            map('n', '<leader>hp', gs.preview_hunk)      -- popup diff of hunk
            map('n', '<leader>hb', gs.blame_line)        -- blame current line
            map('n', '<leader>hB', function() gs.blame_line{full=true} end)
            map('n', '<leader>hd', gs.diffthis)          -- diff vs index
            map('n', '<leader>hD', function() gs.diffthis('~') end) -- vs HEAD

            -- Toggle helpers
            map('n', '<leader>htb', gs.toggle_current_line_blame)
            map('n', '<leader>htd', gs.toggle_deleted)
          end
        '';
      };
    };
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
      options = {
        silent = true;
      };
    }
    {
      action = ":bp<cr>";
      key = "<leader>[";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
    {
      action = ":bn<cr>";
      key = "<leader>]";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
    # Fugitive Keymaps
    {
      action = ":tab Git<cr>";
      key = "<leader>gs";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
    {
      action = ":Git commit<cr>";
      key = "<leader>gc";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
    {
      action = ":Git add %<cr>";
      key = "<leader>ga";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
    {
      action = ":Git add -A<cr>";
      key = "<leader>gA";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
    {
      action = ":Git push<cr>";
      key = "<leader>gp";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
    {
      action = ":Git pull --rebase<cr>";
      key = "<leader>gP";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
    {
      action = ":Gclog<cr>";
      key = "<leader>gl";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
    {
      action = ":Git log --oneline --decorate --graph<cr>";
      key = "<leader>gL";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
    {
      action = ":Git blame<cr>";
      key = "<leader>gb";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
    {
      action = ":GBrowse<cr>";
      key = "<leader>gB";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
    {
      action = ":Gdiffsplit<cr>";
      key = "<leader>gd";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
    {
      action = ":Gvdiffsplit!<cr>";
      key = "<leader>gD";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
    {
      action = ":Gread<cr>";
      key = "<leader>gr";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
    {
      action = ":Gwrite<cr>";
      key = "<leader>gw";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
    {
      action = ":Git stash -k<cr>";
      key = "<leader>gst";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
    {
      action = ":Git stash popk<cr>";
      key = "<leader>gsp";
      mode = [ "n" ];
      options = {
        silent = true;
      };
    }
  ];
}
