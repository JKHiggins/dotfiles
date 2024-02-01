local M = {}

function M.post()
  _G.NEOTEST_LOADED = true
  local neotest = require("neotest")
  local lib = require("neotest.lib")
  local get_env = function()
    local env = {}
    local file = ".env"
    if not lib.files.exists(file) then
      return {}
    end

    for _, line in ipairs(vim.fn.readfile(file)) do
      for name, value in string.gmatch(line, "(%S+)=['\"]?(.*)['\"]?") do
        local str_end = string.sub(value, -1, -1)
        if str_end == "'" or str_end == '"' then
          value = string.sub(value, 1, -2)
        end

        env[name] = value
      end
    end
    return env
  end
  neotest.setup({
    log_level = vim.log.levels.DEBUG,
    quickfix = {
      open = false,
    },
    status = {
      virtual_text = true,
      signs = true,
    },
    output = {
      open_on_run = false,

    },
    icons = {
      running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
    },
    strategies = {
      integrated = {
        width = 180,
      },
    },
    adapters = {
      require("neotest-python")({
        dap = { justMyCode = false, console = "integratedTerminal", subProcess = false },
        pytest_discovery = true,
      }),
      require("neotest-plenary"),
    },
  })

  local group = vim.api.nvim_create_augroup("NeotestConfig", {})
  for _, ft in ipairs({ "output", "attach", "summary" }) do
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "neotest-" .. ft,
      group = group,
      callback = function(opts)
        vim.keymap.set("n", "q", function()
          pcall(vim.api.nvim_win_close, 0, true)
        end, {
          buffer = opts.buf,
        })
      end,
    })
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "neotest-output-panel",
    group = group,
    callback = function()
      vim.cmd("norm G")
    end,
  })

  local mappings = {
    ["<leader>tr"] = function()
      neotest.run.run({ vim.fn.expand("%:p"), env = get_env() })
    end,
    ["<leader>ts"] = function()
      for _, adapter_id in ipairs(neotest.state.adapter_ids()) do
        neotest.run.run({ suite = true, adapter = adapter_id, env = get_env() })
      end
    end,
    ["<leader>tx"] = function()
      neotest.run.stop()
    end,
    ["<leader>tn"] = function()
      neotest.run.run({ env = get_env() })
    end,
    ["<leader>td"] = function()
      neotest.run.run({ strategy = "dap", env = get_env() })
    end,
    ["<leader>tl"] = neotest.run.run_last,
    ["<leader>tD"] = function()
      neotest.run.run_last({ strategy = "dap" })
    end,
    ["<leader>ta"] = neotest.run.attach,
    ["<leader>to"] = function()
      neotest.output.open({ enter = true, last_run = true })
    end,
    ["<leader>ti"] = function()
      neotest.output.open({ enter = true })
    end,
    ["<leader>tO"] = function()
      neotest.output.open({ enter = true, short = true })
    end,
    ["<leader>tp"] = neotest.summary.toggle,
    ["<leader>tm"] = neotest.summary.run_marked,
    ["<leader>te"] = neotest.output_panel.toggle,
    ["[t"] = function()
      neotest.jump.prev({ status = "failed" })
    end,
    ["]t"] = function()
      neotest.jump.next({ status = "failed" })
    end,
  }

  for keys, mapping in pairs(mappings) do
    vim.api.nvim_set_keymap("n", keys, "", { callback = mapping, noremap = true })
  end
end

return M
