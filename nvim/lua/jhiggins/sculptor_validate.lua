local M = {}

function M.textfunc(info)
  local list
  if info.quickfix == 1 then
    list = vim.fn.getqflist({ items = 1 }).items
  else
    list = vim.fn.getloclist(info.winid, { items = 1 }).items
  end

  local lines = {}
  for i = info.start_idx, info.end_idx do
    local it = list[i]
    local text = it.text or ""
    local sev = "I"

    if text:find("%[FAIL%]") then
      sev = "E"
    elseif text:find("%[INDETERMINATE%]") then
      sev = "W"
    end

    text = text:gsub("^%[[^%]]+%]%s*", "")

    local fname = ""
    if it.bufnr and it.bufnr > 0 then
      fname = vim.fn.bufname(it.bufnr)
    elseif it.filename and it.filename ~= "" then
      fname = it.filename
    end

    if fname ~= "" then
      fname = vim.fn.fnamemodify(fname, ":.")   -- relative to CWD
      fname = vim.fn.pathshorten(fname)          -- a/b/…/file.py
      fname = string.format("%s:%d", fname, it.lnum or 1)
    end

    lines[#lines+1] = string.format("[%s] %s — %s", sev, text, fname)
  end

  return lines
end

vim.o.quickfixtextfunc = [[v:lua.require'jhiggins.sculptor_validate'.textfunc]]

return M
