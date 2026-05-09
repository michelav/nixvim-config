{
  pkgs,
  lib,
  spellDictionaries ? [ ],
  ...
}:

let
  defaultSpellDictionaries = with pkgs.hunspellDicts; [
    {
      spelllang = "pt";
      spellfile = "pt";
      aliases = [
        "pt"
        "br"
        "pt_br"
      ];
      dict = pt_BR;
    }

    {
      spelllang = "en_us";
      spellfile = "en";
      aliases = [
        "en"
        "us"
      ];
      dict = en_US;
    }

    {
      spelllang = "en_gb";
      spellfile = "en";
      aliases = [
        "gb"
        "uk"
      ];
      dict = en_GB-ise;
    }
  ];

  effectiveSpellDictionaries =
    if spellDictionaries == [ ] then defaultSpellDictionaries else spellDictionaries;

  groupedSpellDictionaries = lib.groupBy (d: d.spellfile) effectiveSpellDictionaries;

  mkSpellFile =
    spellfile: dictionaries:
    pkgs.runCommand "nvim-spell-${spellfile}"
      {
        nativeBuildInputs = [
          pkgs.neovim-unwrapped
          pkgs.coreutils
          pkgs.findutils
        ];
      }
      ''
        set -euo pipefail

        export HOME="$TMPDIR/home"
        export XDG_CACHE_HOME="$TMPDIR/cache"
        export XDG_CONFIG_HOME="$TMPDIR/config"
        export XDG_DATA_HOME="$TMPDIR/data"

        mkdir -p "$HOME" "$out"

        inputs=""

        ${lib.concatMapStringsSep "\n" (d: ''
          aff="$(find ${d.dict} -type f -name '*.aff' | sort | head -n 1)"
          test -n "$aff"

          base="''${aff%.aff}"
          test -f "$base.dic"

          inputs="$inputs $base"
        '') dictionaries}

        nvim \
          --headless \
          -u NONE \
          -i NONE \
          -n \
          --cmd 'set encoding=utf-8' \
          -c "mkspell! $out/${spellfile} $inputs" \
          -c 'qa!'

        test -f "$out/${spellfile}.utf-8.spl"
      '';

  spellRuntime = pkgs.symlinkJoin {
    name = "nvim-spell-runtime";

    paths = lib.mapAttrsToList (
      spellfile: dictionaries:
      pkgs.runCommand "nvim-spell-runtime-${spellfile}" { } ''
        mkdir -p "$out/spell"

        ln -s ${mkSpellFile spellfile dictionaries}/${spellfile}.utf-8.spl \
          "$out/spell/${spellfile}.utf-8.spl"
      ''
    ) groupedSpellDictionaries;
  };

  defaultSpellLang = lib.concatStringsSep "," (map (d: d.spelllang) effectiveSpellDictionaries);

  spellLangsLua = lib.generators.toLua { } (map (d: d.spelllang) effectiveSpellDictionaries);

  aliasesLua = lib.generators.toLua { } (
    builtins.listToAttrs (
      lib.flatten (
        map (
          d:
          map (alias: {
            name = alias;
            value = d.spelllang;
          }) d.aliases
        ) effectiveSpellDictionaries
      )
      ++ [
        {
          name = "all";
          value = defaultSpellLang;
        }
        {
          name = "multi";
          value = defaultSpellLang;
        }
      ]
    )
  );
in
{
  opts = {
    spell = false;
  };

  extraConfigLua = ''
    local spell_runtime = "${spellRuntime}"

    vim.opt.runtimepath:prepend(spell_runtime)
    local available_spelllangs = ${spellLangsLua}
    local default_spelllang = "${defaultSpellLang}"
    local aliases = ${aliasesLua}

    vim.opt.spelllang = default_spelllang

    local personal_spell_dir = vim.fn.stdpath("data") .. "/site/spell"
    vim.fn.mkdir(personal_spell_dir, "p")
    vim.opt.spellfile = personal_spell_dir .. "/personal.utf-8.add"

    local function resolve_spelllang(lang)
      return aliases[lang] or lang
    end

    local function enable_writing_spell()
      vim.opt_local.spell = true
      vim.opt_local.spelllang = default_spelllang
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "markdown",
        "tex",
        "plaintex",
        "typst",
        "rst",
        "gitcommit",
        "text",
        "mail",
      },
      callback = enable_writing_spell,
      desc = "Enable spell checking for writing filetypes",
    })

    vim.api.nvim_create_user_command("SpellLang", function(opts)
      local lang = resolve_spelllang(opts.args)

      vim.opt_local.spell = true
      vim.opt_local.spelllang = lang

      vim.notify("spelllang=" .. lang)
    end, {
      nargs = 1,
      complete = function()
        local completion = {
          "all",
          "multi",
        }

        for alias, _ in pairs(aliases) do
          table.insert(completion, alias)
        end

        for _, lang in ipairs(available_spelllangs) do
          table.insert(completion, lang)
        end

        table.sort(completion)

        return completion
      end,
      desc = "Set local spell language",
    })

    vim.api.nvim_create_user_command("SpellToggle", function()
      vim.opt_local.spell = not vim.opt_local.spell:get()
      vim.notify("spell=" .. tostring(vim.opt_local.spell:get()))
    end, {
      desc = "Toggle spell checking for current buffer",
    })

    vim.keymap.set("n", "<leader>st", "<cmd>SpellToggle<cr>", {
      desc = "Toggle spell check",
    })

    vim.keymap.set("n", "<leader>sp", "<cmd>SpellLang pt<cr>", {
      desc = "Spell: Portuguese",
    })

    vim.keymap.set("n", "<leader>se", "<cmd>SpellLang en<cr>", {
      desc = "Spell: English (US)",
    })

    vim.keymap.set("n", "<leader>sg", "<cmd>SpellLang gb<cr>", {
      desc = "Spell: English (GB)",
    })

    vim.keymap.set("n", "<leader>sm", "<cmd>SpellLang multi<cr>", {
      desc = "Spell: multilingual",
    })

    vim.keymap.set("n", "<leader>sn", "]s", {
      desc = "Next spelling error",
    })

    vim.keymap.set("n", "<leader>sN", "[s", {
      desc = "Previous spelling error",
    })

    vim.keymap.set("n", "<leader>ss", function()
      require("telescope.builtin").spell_suggest()
    end, {
      desc = "Spelling suggestions",
    })

    vim.keymap.set("n", "<leader>sa", "zg", {
      desc = "Add word to dictionary",
    })

    vim.keymap.set("n", "<leader>sw", "zw", {
      desc = "Mark word as wrong",
    })

    vim.keymap.set("n", "<leader>su", "zug", {
      desc = "Undo word add/remove",
    })
  '';
}
