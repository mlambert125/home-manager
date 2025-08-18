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
vim.opt.signcolumn = "yes:1"
vim.api.nvim_set_option("clipboard", "unnamedplus")


------------------------------------------------------------------------
-- PLUGINS 
------------------------------------------------------------------------
vim.pack.add {"https://github.com/nvim-lua/plenary.nvim"}
vim.pack.add {"https://github.com/MunifTanjim/nui.nvim"}
vim.pack.add {"https://github.com/nvim-neotest/nvim-nio"}
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
require("dap").adapters.lldb = {
    type = "executable",
    command = "lldb-dap",
    name = "lldb",
}
require("dap").configurations.rust = {
    {
        name = "Debug current binary",
        type = "lldb",
        request = "launch",
        program = function()
            -- default to target/debug/, but let you pick any file
            return vim.fn.input("Path to executable: ",
            vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},                 -- e.g. { "--flag" }
        env = { RUST_BACKTRACE = "1" }, -- optional
        runInTerminal = false,     -- true if you prefer external terminal
    }
}

vim.pack.add {"https://github.com/rcarriga/nvim-dap-ui"}
require("dapui").setup()
require("dap").listeners.before.attach.dapui_config = function()
  require("dapui").open()
end
require("dap").listeners.before.launch.dapui_config = function()
  require("dapui").open()
end
require("dap").listeners.before.event_terminated.dapui_config = function()
  require("dapui").close()
end
require("dap").listeners.before.event_exited.dapui_config = function()
  require("dapui").close()
end
vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

vim.fn.sign_define("DapBreakpoint",          { text = "", texthl = "DiagnosticSignError", linehl = "",                 numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticSignWarn",  linehl = "",                 numhl = "" })
vim.fn.sign_define("DapBreakpointRejected",  { text = "", texthl = "DiagnosticSignError", linehl = "",                 numhl = "" })
vim.fn.sign_define("DapLogPoint",            { text = "", texthl = "DiagnosticSignInfo",  linehl = "",                 numhl = "" })
vim.fn.sign_define("DapStopped",             { text = "", texthl = "DiagnosticSignInfo",  linehl = "DapStoppedLine",   numhl = "" })


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
-- Easy window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- Clear highlight on escape
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Visual mode line movement
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move the highlighted line(s) down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move the highlighted line(s) up" })

-- Some Helix go commands that I miss
vim.keymap.set("n", "gh", "^", { noremap = true, silent = true, desc = "Goto Start of Line" })
vim.keymap.set("n", "gl", "$", { noremap = true, silent = true, desc = "Goto End of Line" })

-- Helix style "x" thing
vim.keymap.set("n", "x", "V", { noremap = true, silent = true, desc = "Highlight Line" })
vim.keymap.set("v", "x", "j", { noremap = true, silent = true, desc = "Highlight Next Line" })
vim.keymap.set("v", ",", "<Esc>", { noremap = true, silent = true, desc = "Exit Visual Mode" })

-- Redo is capital U
vim.keymap.set("n", "U", "<C-r>", { noremap = true, silent = true, desc = "Redo" })

-- Center after jump to end, find, page up/down
vim.keymap.set("n", "G", "Gzz", { noremap = true, silent = true, desc = "Goto End of Buffer" })
vim.keymap.set("n", "n", "nzz", { noremap = true, silent = true, desc = "Goto Next Search Result" })
vim.keymap.set("n", "N", "Nzz", { noremap = true, silent = true, desc = "Goto Previous Search Result" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true, desc = "Page Down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true, desc = "Page Up" })

-- Keep visual selection while indenting
vim.api.nvim_set_keymap("v", ">", ">gv", {noremap = true, silent = true, desc = "Indent Selection"})
vim.api.nvim_set_keymap("v", "<", "<gv", {noremap = true, silent = true, desc = "Deindent Selection"})

-- Telescope
vim.keymap.set("n", "<leader> ", require("telescope.builtin").find_files, { desc = "Telescope Find Files" })
vim.keymap.set("n", "<leader>fr", require("telescope.builtin").oldfiles, { desc = "Telescope Recent Files" })
vim.keymap.set("n", "<leader>/", require("telescope.builtin").live_grep, { desc = "Telescope Live Grep" })

-- Bufferline
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { noremap = true, silent = true, desc = "Buffer Close Self" })
vim.keymap.set("n", "<leader>bo", ":BufferLineCloseOthers<CR>", { noremap = true, silent = true, desc = "Buffer Close Others" })
vim.keymap.set("n", "<leader>bl", ":BufferLineCloseLeft<CR>", { noremap = true, silent = true, desc = "Buffer Close Left" })
vim.keymap.set("n", "<leader>br", ":BufferLineCloseRight<CR>", { noremap = true, silent = true, desc = "Buffer Close Right" })
vim.keymap.set("n", "H", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true, desc = "Previous Buffer" })
vim.keymap.set("n", "L", ":BufferLineCycleNext<CR>", { noremap = true, silent = true, desc = "Next Buffer" })

-- Neotree 
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true, desc = "Toggle NeoTree" })

-- LSP keymaps
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true, desc = "Goto Definition" })

-- Persistence 
vim.keymap.set("n", "<leader>s", require("persistence").load, { noremap = true, silent = true, desc = "Restore Session" })

-- DAP
vim.keymap.set("n", "<leader>dc",  function() require("dap").continue() end, { desc = "Debug Start/Continue" })
vim.keymap.set("n", "<leader>do", function() require("dap").step_over() end, { desc = "Debug Step Over" })
vim.keymap.set("n", "<leader>di", function() require("dap").step_into() end, { desc = "Debug Step Into" })
vim.keymap.set("n", "<leader>du", function() require("dap").step_out() end, { desc = "Debug Step Out" })
vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Debug Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "Debug Set Conditional Breakpoint" })

vim.keymap.set("n", "<leader>dt", function()
    if require("dap").session() then
        require("dap").terminate()
        require("dap").disconnect({ terminateDebuggee = true })
    end
    require("dapui").close()
end, { desc = "Debug Terminate" })
