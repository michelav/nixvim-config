{ pkgs, ... }:

{
  extraPackages = [
    pkgs.ripgrep
  ];

  opts = {
    grepprg = "rg --vimgrep --smart-case --hidden --glob '!**/.git/**'";
    grepformat = "%f:%l:%c:%m";
  };
  extraConfigLua = ''
    local function shell_like_unquote(s)
      if s == nil then
        return ""
      end

      local first = s:sub(1, 1)
      local last = s:sub(-1)

      if #s >= 2 and first == last and (first == '"' or first == "'") then
        s = s:sub(2, -2)

        -- Simula o caso comum do shell em strings com aspas duplas:
        -- "answers\\.jsonl" vira answers\.jsonl para o rg.
        if first == '"' then
          s = s:gsub("\\\\", "\\")
          s = s:gsub('\\"', '"')
        end
      end

      return s
    end

    local function rg_to_quickfix(pattern, paths)
      pattern = shell_like_unquote(vim.trim(pattern or ""))
      paths = paths or {}

      if pattern == "" then
        vim.notify("Busca vazia", vim.log.levels.WARN)
        return
      end

      local cmd = {
        "rg",
        "--vimgrep",
        "--smart-case",
        "--hidden",
        "--glob",
        "!**/.git/**",
        "--",
        pattern,
      }

      for _, path in ipairs(paths) do
        table.insert(cmd, path)
      end

      local result = vim.system(cmd, { text = true }):wait()

      if result.code > 1 then
        local msg = result.stderr or result.stdout or "Erro ao executar rg"
        vim.notify(msg, vim.log.levels.ERROR)
        return
      end

      local lines = vim.split(result.stdout or "", "\n", {
        trimempty = true,
      })

      vim.fn.setqflist({}, "r", {
        title = "rg: " .. pattern,
        lines = lines,
        efm = "%f:%l:%c:%m",
      })

      if #lines == 0 then
        vim.notify("Nenhum resultado para: " .. pattern, vim.log.levels.INFO)
        return
      end

      local ok = pcall(vim.cmd, "Trouble qflist open focus=true")

      if not ok then
        vim.cmd("copen")
      end
    end

    local function qf_remove_current_and_go_next()
      local info = vim.fn.getqflist({
        title = 0,
        items = 0,
        idx = 0,
      })

      local items = info.items or {}

      if #items == 0 then
        vim.notify("Quickfix vazia", vim.log.levels.INFO)
        return
      end

      local idx = info.idx

      if vim.bo.filetype == "qf" then
        idx = vim.fn.line(".")
      end

      if idx < 1 or idx > #items then
        vim.notify("Item quickfix inválido", vim.log.levels.WARN)
        return
      end

      table.remove(items, idx)

      if #items == 0 then
        vim.fn.setqflist({}, "r", {
          title = info.title,
          items = {},
        })
        vim.cmd("cclose")
        vim.notify("Quickfix vazia", vim.log.levels.INFO)
        return
      end

      local next_idx = math.min(idx, #items)

      vim.fn.setqflist({}, "r", {
        title = info.title,
        items = items,
        idx = next_idx,
      })

      vim.cmd("cc")
    end

    vim.api.nvim_create_user_command("RgReview", function(opts)
      local parts = vim.split(opts.args, "%s+", {
        trimempty = true,
      })

      if #parts == 0 then
        vim.notify("Uso: :RgReview {pattern} [paths...]", vim.log.levels.WARN)
        return
      end

      local pattern = table.remove(parts, 1)
      rg_to_quickfix(pattern, parts)
    end, {
      nargs = "+",
      complete = "file",
      desc = "Search with ripgrep, populate quickfix, and open Trouble",
    })

    vim.keymap.set("n", "<leader>rr", function()
      vim.ui.input({ prompt = "rg review> " }, function(input)
        if input == nil or input == "" then
          return
        end

        rg_to_quickfix(input, {})
      end)
    end, {
      desc = "Ripgrep review into quickfix/Trouble",
    })

    vim.keymap.set("n", "<leader>rw", function()
      rg_to_quickfix(vim.fn.expand("<cword>"), {})
    end, {
      desc = "Ripgrep word under cursor into quickfix/Trouble",
    })

    vim.keymap.set("n", "<leader>ro", "<cmd>Trouble qflist open focus=true<cr>", {
      desc = "Open quickfix in Trouble",
    })

    vim.keymap.set("n", "<leader>rt", "<cmd>Trouble qflist toggle focus=true<cr>", {
      desc = "Toggle quickfix in Trouble",
    })

    vim.keymap.set("n", "<leader>rd", qf_remove_current_and_go_next, {
      desc = "Remove current quickfix item and go next",
    })

    vim.keymap.set("n", "<leader>rn", "<cmd>cnext<cr>zz", {
      desc = "Next quickfix item",
    })

    vim.keymap.set("n", "<leader>rp", "<cmd>cprev<cr>zz", {
      desc = "Previous quickfix item",
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "qf",
      callback = function(event)
        vim.keymap.set("n", "dd", qf_remove_current_and_go_next, {
          buffer = event.buf,
          desc = "Remove quickfix item and go next",
        })

        vim.keymap.set("n", "x", qf_remove_current_and_go_next, {
          buffer = event.buf,
          desc = "Remove quickfix item and go next",
        })

        vim.keymap.set("n", "q", "<cmd>cclose<cr>", {
          buffer = event.buf,
          desc = "Close quickfix",
        })
      end,
    })
  '';
}
