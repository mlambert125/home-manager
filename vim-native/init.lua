------------------------------------------------------------------------
-- OPTIONS
------------------------------------------------------------------------
vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.undofile = true
vim.api.nvim_set_option("clipboard", "unnamedplus")


------------------------------------------------------------------------
-- PLUGINS 
------------------------------------------------------------------------
vim.pack.add {"https://github.com/nvim-lua/plenary.nvim"}
vim.pack.add {"https://github.com/MunifTanjim/nui.nvim"}
vim.pack.add {"https://github.com/echasnovski/mini.icons"}
vim.pack.add {"https://github.com/nvim-tree/nvim-web-devicons"}
vim.pack.add {"https://github.com/nvim-treesitter/nvim-treesitter"}
vim.pack.add {"https://github.com/neovim/nvim-lspconfig"}

--vim.pack.add {"https://github.com/github/copilot.vim"}

vim.pack.add {"https://github.com/folke/persistence.nvim"}
require("persistence").setup {
    dir = vim.fn.expand(vim.fn.stdpath "data" .. "/sessions/"),
    options = { "buffers", "curdir", "tabpages", "winsize" },
    pre_save = function()
        vim.cmd "Neotree close"
    end,
}

vim.pack.add {"https://github.com/nvimdev/dashboard-nvim"}
require("dashboard").setup {
    theme = "hyper",
    config = {
        header = {
            "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
            "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
            "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
            "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
            "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
            "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
        },
        center = {
            { icon = "  ", desc = "Recently opened files", action = "Telescope oldfiles", shortcut = "SPC f r" },
            { icon = "  ", desc = "Find File          ", action = "Telescope find_files", shortcut = "SPC f f" },
            { icon = "  ", desc = "File Explorer      ", action = "Neotree toggle", shortcut = "SPC e" },
            { icon = "  ", desc = "Find Word          ", action = "Telescope live_grep", shortcut = "SPC /" },
        },
        footer = { "" },
    }
}

vim.pack.add {"https://github.com/nvim-neo-tree/neo-tree.nvim"}

vim.pack.add {"https://github.com/catppuccin/nvim"}
vim.cmd "colorscheme catppuccin-mocha"

vim.pack.add {"https://github.com/nvim-telescope/telescope.nvim"}

vim.pack.add {"https://github.com/folke/which-key.nvim"}
require("which-key").setup {
    preset = "helix"
}

vim.pack.add {"https://github.com/akinsho/bufferline.nvim"}
require("bufferline").setup {
    options = {
        offsets = {
            {
                filetype = 'neo-tree', -- Target the neo-tree window
                text_align = 'center', -- Optional: alignment of the text
                highlight = 'Directory', -- Optional: highlight group for the offset area
            },
        },
    },
}

vim.pack.add {"https://github.com/echasnovski/mini.completion"}
require("mini.completion").setup {
    auto_setup = true,
    completion = {
        sources = {
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
        },
    },
}

vim.pack.add {"https://github.com/mfussenegger/nvim-dap"}


------------------------------------------------------------------------
-- LSP Configuration
------------------------------------------------------------------------
vim.lsp.config("rust_analyzer", {})
vim.lsp.enable("rust_analyzer")

vim.lsp.config("omnisharp", {})
vim.lsp.enable("omnisharp")


------------------------------------------------------------------------
-- KEYMAPS 
------------------------------------------------------------------------
-- The jj escape thing
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })

-- Easy window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- Visual mode line movement
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

-- Keep visual selection while indenting
vim.api.nvim_set_keymap("v", "<", "<gv", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", ">", ">gv", {noremap = true, silent = true})

-- Telescope
vim.keymap.set("n", "<leader> ", require("telescope.builtin").find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fr", require("telescope.builtin").oldfiles, { desc = "Telescope recent files" })
vim.keymap.set("n", "<leader>/", require("telescope.builtin").live_grep, { desc = "Telescope live grep" })

-- Bufferline
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bo", ":BufferLineCloseOthers<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bl", ":BufferLineCloseLeft<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>br", ":BufferLineCloseRight<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "H", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "L", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })

-- Neotree 
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })

-- LSP keymaps
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", {noremap = true, silent = true})

-- Persistence 
vim.keymap.set("n", "<leader>s", require("persistence").load, { noremap = true, silent = true })

