{ lib, ... }:
{
  diagnostic.settings = {
    update_in_insert = true;
    underline = true;
    virtual_text = false;
    float = {
      border = "rounded";
      source = "if_many";
    };
  };

  colorschemes.base16 = {
    enable = true;
    colorscheme = lib.mkDefault "nord";
  };

  extraConfigLua = ''
    local function set_spell_highlights()
      local c = require("base16-colorscheme").colors

      -- SpellBad: palavras incorretas
      vim.api.nvim_set_hl(0, "SpellBad", {
        undercurl = true,
        sp = c.base08,
      })

      -- SpellCap: capitalização suspeita
      vim.api.nvim_set_hl(0, "SpellCap", {
        undercurl = true,
        sp = c.base0A,
      })

      -- SpellRare: palavra rara/incomum
      vim.api.nvim_set_hl(0, "SpellRare", {
        undercurl = true,
        sp = c.base0E,
      })

      -- SpellLocal: palavra válida em outra região/localidade
      vim.api.nvim_set_hl(0, "SpellLocal", {
        undercurl = true,
        sp = c.base0C,
      })

      -- Mantém diagnósticos LSP visualmente consistentes.
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", {
        undercurl = true,
        sp = c.base08,
      })

      vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", {
        undercurl = true,
        sp = c.base0A,
      })

      vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", {
        undercurl = true,
        sp = c.base0C,
      })

      vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", {
        undercurl = true,
        sp = c.base0B,
      })
    end

    set_spell_highlights()

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = set_spell_highlights,
      desc = "Apply custom spell and diagnostic underline highlights",
    })
  '';
  plugins = {
    todo-comments.enable = true;
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
        sections.lualine_x = [
          {
            __unkeyed-1 = {
              __raw = ''
                function() return vim.wo.wrap and "[WRAP]" or "" end,
                cond = function() return true end,     -- render only if non-empty
                color = function()
                  if vim.wo.wrap then return { gui = "bold" } end
                end,
                padding = { left = 1, right = 1 },
                separator = "",
              '';
            };
          }
          "encoding"
          "fileformat"
          "filetype"
        ];
      };
    };
  };
}
