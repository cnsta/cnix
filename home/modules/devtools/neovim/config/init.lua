-- Faster completion
vim.opt.updatetime = 100

-- Line numbers
vim.opt.relativenumber = false -- Relative line numbers
vim.opt.number = true -- Display the absolute line number of the current line

-- Buffer and window options
vim.opt.hidden = true -- Keep closed buffer open in the background
vim.opt.showmode = false -- Do not show the mode in the command line
vim.opt.mouse = "a" -- Enable mouse control
vim.opt.mousemodel = "popup" -- Mouse right-click extends the current selection
vim.opt.splitbelow = true -- A new window is put below the current one
vim.opt.splitright = true -- A new window is put right of the current one

-- List options
vim.opt.list = true
vim.opt.listchars = {
	tab = "▷ ",
	trail = "·",
	nbsp = "○",
	extends = "◣",
	precedes = "◢",
}

-- Swap and undo files
vim.opt.swapfile = false -- Disable the swap file
vim.opt.modeline = true -- Tags such as 'vim:ft=sh'
vim.opt.modelines = 100 -- Sets the type of modelines
vim.opt.undofile = true -- Automatically save and restore undo history

-- Search options
vim.opt.incsearch = true -- Incremental search: show match for partly typed search command
vim.opt.inccommand = "split" -- Search and replace: preview changes in quickfix list
vim.opt.ignorecase = true -- When the search query is lower-case, match both lower and upper-case patterns
vim.opt.smartcase = true -- Override the 'ignorecase' option if the search pattern contains upper case characters

-- Scrolling and cursor options
vim.opt.scrolloff = 4 -- Number of screen lines to show around the cursor
vim.opt.cursorline = true -- Highlight the screen line of the cursor
vim.opt.cursorcolumn = false -- Highlight the screen column of the cursor
vim.opt.signcolumn = "yes" -- Whether to show the signcolumn

-- Display options
vim.opt.colorcolumn = "" -- Columns to highlight
vim.opt.laststatus = 3 -- When to use a status line for the last window
vim.opt.fileencoding = "utf-8" -- File-content encoding for the current buffer
vim.opt.spell = false -- Highlight spelling mistakes (local to window)
vim.opt.wrap = false -- Prevent text from wrapping

-- Tab options
vim.opt.tabstop = 4 -- Number of spaces a <Tab> in the text stands for (local to buffer)
vim.opt.shiftwidth = 4 -- Number of spaces used for each step of (auto)indent (local to buffer)
vim.opt.expandtab = true -- Expand <Tab> to spaces in Insert mode (local to buffer)
vim.opt.autoindent = true -- Do clever autoindenting

-- Text width
vim.opt.textwidth = 0 -- Maximum width of text that is being inserted

-- Folding
vim.opt.foldlevel = 99 -- Folds with a level higher than this number will be closed
