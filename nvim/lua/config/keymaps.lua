-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- The jj escape thing
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move the highlighted line(s) down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move the highlighted line(s) up" })

-- Some Helix go commands that I miss
vim.keymap.set("n", "ge", "G", { noremap = true, silent = true })
vim.keymap.set("n", "gh", "^", { noremap = true, silent = true })
vim.keymap.set("n", "gl", "$", { noremap = true, silent = true })

-- Helix style "x" thing
vim.keymap.set("n", "x", "V", { noremap = true, silent = true })
vim.keymap.set("v", "x", "j", { noremap = true, silent = true })
vim.keymap.set("v", ",", "<Esc>", { noremap = true, silent = true })

-- Redo is capital U
vim.keymap.set("n", "U", "<C-r>", { noremap = true, silent = true })

-- Center after jump to end, find, page up/down
vim.keymap.set("n", "G", "Gzz", { noremap = true, silent = true })
vim.keymap.set("n", "n", "nzz", { noremap = true, silent = true })
vim.keymap.set("n", "N", "Nzz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

-- Delete mark
vim.keymap.set({ "n" }, "dm", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local cur_line = vim.fn.line(".")
  ---@type { mark: string, pos: number[] }[]
  local all_marks_local = vim.fn.getmarklist(bufnr)
  for _, mark in ipairs(all_marks_local) do
    if mark.pos[2] == cur_line and string.match(mark.mark, "'[a-z]") then
      vim.notify("Deleting mark: " .. string.sub(mark.mark, 2, 2))
      vim.api.nvim_buf_del_mark(bufnr, string.sub(mark.mark, 2, 2))
    end
  end

  local bufname = vim.api.nvim_buf_get_name(bufnr)
  ---@type { file: string, mark: string, pos: number[] }[]
  local all_marks_global = vim.fn.getmarklist()
  for _, mark in ipairs(all_marks_global) do
    local expanded_file_name = vim.fn.fnamemodify(mark.file, ":p")
    if bufname == expanded_file_name and mark.pos[2] == cur_line and string.match(mark.mark, "'[A-Z]") then
      vim.notify("Deleting mark: " .. string.sub(mark.mark, 2, 2))
      vim.api.nvim_del_mark(string.sub(mark.mark, 2, 2))
    end
  end
end, { desc = "Delete all marks for current line" })
