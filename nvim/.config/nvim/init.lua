-- Base Options & Mappings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.netrw_banner = 0

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.splitright = true
opt.splitbelow = true
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.termguicolors = true
opt.updatetime = 250
opt.timeoutlen = 300

local function get_secret_key()
	local home = os.getenv("HOME")
	local file = io.open(home .. "/lockbox/.gemini_key", "r")
	if not file then return  "" end
	local key = file:read("*all"):gsub("%s+", "")
	file:close()
	return key
end
vim.env.GEMINI_API_KEY = get_secret_key()

-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", "--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        local hl_groups = {
            "Normal",
            "NormalNC",
            "SignColumn",
            "NormalFloat",
            "FloatBorder",
            "TelescopeNormal",
            "TelescopeBorder",
        }
        for _, group in ipairs(hl_groups) do 
            vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
        end 
    end,
})

-- Plugin Definitions
require("lazy").setup({
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme carbonfox]])
		end,
	},
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("bufferline").setup({
                options = {
                    mode = "buffers",
                    separator_style = "thin",
                    always_show_bufferline = true,
                    show_buffer_close_icons = true,
                    show_close_icon = false,
                    diagnostics = "nvim_lsp",
                    offsets = {
                        {
                            filetype = "netrw",
                            text = "File Explorer",
                            text_align = "left",
                            separator = true,
                        },
                    },
                },
            })
        end,
    },
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			wk.setup()
			wk.add({
				{ "<leader>f", group = "Files" },
				{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
				{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
				{ "<leader>e", "<cmd>Lex 25<cr>", desc = "Toggle File Explorer" },
                { "<leader>b", group = "Buffers" },
                { "<leader>bc", "<cmd>bdelete<cr>", desc = "Close Current Buffer" },
                { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer Tab" },
                { "<leader>bse", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort by Extension" },
                { "<leader>bsd", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort by Directory" },
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {}
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.config").setup({
				ensure_installed = { "go", "java", "python", "lua", "sql", "markdown" },
				highlight = { enabled = true },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "gopls", "jdtls", "pyright" }
			})
            local caps = require("cmp_nvim_lsp").default_capabilities()
            for _, server in ipairs({ "gopls", "pyright", "jdtls" }) do
                vim.lsp.config(server, { capabilities = caps })
                vim.lsp.enable(server)
            end
	end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<A-y>"] = cmp.mapping(function()
						require("minuet").make_cmp_map()()
					end, { "i" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "minuet" },
					{ name = "path" },
					{ name = "buffer" },
				}),
				performance = {
					fetching_timeout = 2000,
				}
			})
		end,
	},
})

-- Keymappings
vim.keymap.set("n", "H", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer Tab" })
vim.keymap.set("n", "L", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer Tab" })
