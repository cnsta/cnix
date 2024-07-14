local map = vim.keymap.set

local close_nvim = function()
	vim.cmd("Neotree close")
	vim.cmd("qa")
end

--- General
map("n", "+", "/", { desc = "Forward search", nowait = true })
map("n", "-", "?", { desc = "Backward search", nowait = true })
map("n", "<leader>n", "<cmd>enew<cr>", { desc = "New Buffer" })
map({ "n", "t" }, "<A-w>", "<cmd>q<cr>", { desc = "Close Window" })
map({ "n", "t" }, "<C-q>", close_nvim, { desc = "Quick Quit" })
map({ "n", "x" }, ",", ":", { desc = "Enter command mode", nowait = true })

map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Open Lazy" })
map("n", "<leader>mm", "<cmd>Mason<cr>", { desc = "Open Mason" })

map("i", "<C-v>", "<esc>p", { desc = "Paste Clipboard" })
map("n", "<C-c>", "<cmd> %y+ <CR>", { desc = "Copy File to [C]lipboard" })

map({ "i", "x", "n", "s" }, "<C-s>", '<cmd>w "++p"<cr><esc>', { desc = "Save File" })
map(
	{ "i", "x", "n", "s" },
	"<Esc><C-s>", -- <Alt>+<Control-s>
	'<cmd>wa "++p"<cr><esc>',
	{ desc = "Save All Files" }
)

map(
	"n",
	"<leader>cr",
	"<cmd>let @+ = expand('%:~:.')<cr><cmd>echo 'Copied path:' @+<cr>",
	{ desc = "[C]opy [R]elative Path to Clipboard" }
)
map(
	"n",
	"<leader>cp",
	"<cmd>let @+ = expand('%:p')<cr><cmd>echo 'Copied path:' @+<cr>",
	{ desc = "[C]opy Full [P]ath to Clipboard" }
)
map("n", "<leader>gp", ":e <C-r>+<CR>", { desc = "[G]o to [P]ath from Clipboard" })

map("v", ">", ">gv", { desc = "Indent Right" })
map("v", "<", "<gv", { desc = "Indent Left" })

-- Don't copy the replaced text after pasting in visual mode
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
map("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Dont copy replaced text", silent = true })

-- Don't reset clipboard after first paste in Visual mode
map("v", "p", "P")

--- Tab motions
-- map('n', '<C-t>s', '<cmd>tab split<cr>', { desc = 'Split Window to New Tab' })
-- map('n', '<C-t>t', '<C-w>T', { desc = 'Maximize Window' })
map("n", "<ESC><C-j>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<ESC><C-k>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "[T]ab [C]lose" })
map("n", "<leader>te", "<cmd>tabedit<cr>", { desc = "[T]ab [E]dit" })
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "[T]ab [N]ew" })

-- Buffer Motions
-- map('n', '<A-j>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
-- map('n', '<A-k>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
-- map('n', '<A-c>', '<cmd>bdelete<cr>', { desc = 'Close Buffer' })

--- Debugging
map("n", "<leader>ms", "<cmd>messages<cr>", { desc = "Show Messages" })
map("n", "<leader>mn", "<cmd>Noice<cr>", { desc = "Show Noice Messages" })

map("x", "<M-s>", ":sort<cr>", { desc = "Sort Selection" })

--- Terminal
-- switch between windows
map("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Terminal Window Left" })
map("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Terminal Window Right" })
map("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Terminal Window Down" })
map("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Terminal Window Up" })
map("t", "<C-x>", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), { desc = "Escape Terminal Mode" })

-- Better Movements
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move Lines
-- map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move Down' })
-- map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move Up' })
-- map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
-- map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
-- map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move Down' })
-- map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move Up' })

-- Resize window using <ctrl> arrow keys
map({ "n", "t" }, "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map({ "n", "t" }, "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map({ "n", "t" }, "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map({ "n", "t" }, "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / Clear hlsearch / Diff Update" }
)
