-- Centers cursor when moving 1/2 page down
lvim.keys.normal_mode["<C-d>"] = "<C-d>zz"

-- Source the current config file
lvim.keys.normal_mode["<leader><leader>"] = vim.cmd.so

-- UndoTree
lvim.keys.normal_mode["<leader>u"] = vim.cmd.UndotreeToggle
vim.keymap.set("i", "jj", "<Esc>")

vim.cmd.autocmd("BufRead,BufNewFile */waybar/config setfiletype json")
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.o.termguicolors = true
vim.opt.background = "dark"

-- Plugins
lvim.plugins = {
	{ "mbbill/undotree" },
	{ "rust-lang/rust.vim" },
	{ "andweeb/presence.nvim" },
	{ "nvim-treesitter/nvim-treesitter-context" },
	{
		"simrat39/rust-tools.nvim",
		config = function()
			require("rust-tools").setup({
				inlay_hints = true,
			})
		end,
	},
	{ "navarasu/onedark.nvim" },
	{ "fatih/vim-go" },
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		config = function()
			require("fidget").setup()
		end,
	},
}
