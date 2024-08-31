require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		disable = {},
	},
	rainbow = {
		enable = true,
		extended_mode = true,
	},
	autotag = {
		enable = true,
	},
	context_commentstring = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
})
