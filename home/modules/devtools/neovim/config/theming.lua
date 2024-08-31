-- Set colorscheme
vim.cmd("set termguicolors")

-- Configure gruvbox-material
vim.g.gruvbox_material_background = "medium" -- Options: 'hard', 'medium', 'soft'
vim.g.gruvbox_material_palette = "material" -- Options: 'material', 'original', 'palenight'

-- Load the gruvbox-material colorscheme
vim.cmd([[colorscheme gruvbox-material]])

-- Enable colorizer
require("colorizer").setup()
-- set sign
vim.cmd("sign define DiagnosticSignError text=  linehl= texthl=DiagnosticSignError numhl=")
vim.cmd("sign define DiagnosticSignHint text=  linehl= texthl=DiagnosticSignHint numhl=")
vim.cmd("sign define DiagnosticSignInfo text=  linehl= texthl=DiagnosticSignInfo numhl=")
vim.cmd("sign define DiagnosticSignWarn text=  linehl= texthl=DiagnosticSignWarn numhl=")

-- set lightline theme to horizon
vim.g.lightline = { colorscheme = "apprentice" }
