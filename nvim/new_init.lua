------------ BASICS ------------
-- Themes & Transparency
-- vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
-- vim.api.nvim_set_hl(0, "NormalNC", {bg = "none"})
-- vim.api.nvim_set_hl(0, "EndOfBuffer", {bg = "none"})

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10				-- keep 10 lines above/below cursor 
vim.opt.sidescrolloff = 8			-- keep 8 columns left/right of cursor
vim.opt.undofile = true
vim.opt.signcolumn = 'yes'

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true 			-- use space instead of tabs

vim.opt.smartindent = true			
vim.opt.autoindent = true
vim.opt.breakindent = true    -- have same indentation on line break

vim.opt.list = true
vim.opt.listchars = { tab = '   ', trail = '·', nbsp = '␣' }

-- Neovim-specific search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Sync clipboard between OS and Neovim
-- Schedule is needed because it can increase startup-time
vim.schedule(function()
  vim.opt.clipboard='unnamedplus'
end)

-- Preview substitutions live, as you type
vim.opt.inccommand = 'split'

------------ KEYMAPS ------------

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Clear highlights with <Esc>
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal with double <Esc> instead of <C\><C-n>
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

------------ AUTOCOMMANDS ------------

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight after yanking text',
  callback = function()
    vim.highlight.on_yank()
  end,
})















