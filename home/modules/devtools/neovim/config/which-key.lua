-- Updated Which-Key Spec
local wk = require("which-key")

wk.setup {}

wk.register({
  ["<leader>"] = {
    ["/"] = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
    P = { '"+P', "Paste from clipboard before cursor" },
    a = { "<cmd>lua require('telescope.builtin').lsp_code_actions()<cr>", "Code Actions" },
    ac = { "<cmd>CopilotChatToggle<CR>", "Toggle Copilot chat" },
    b = { "<cmd>Telescope buffers<cr>", "Buffers" },
    d = { "<cmd>lua require('telescope.builtin').lsp_document_diagnostics()<cr>", "LSP Diagnostics" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    g = {
      b = { "<cmd>ToggleBlameLine<cr>", "Toggle BlameLine" },
      c = { "<cmd>Neogit commit<cr>", "Commit" },
      i = { "<cmd>lua require('telescope').extensions.gh.issues()<cr>", "Github Issues" },
      name = "Git / VCS",
      p = { "<cmd>lua require('telescope').extensions.gh.pull_request()<cr>", "Github PRs" },
      s = { "<cmd>Neogit kind=split<cr>", "Staging" }
    },
    k = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help" },
    l = {
      e = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", "Show Line Diagnostics" },
      f = { "<cmd>lua vim.lsp.buf.formatting_sync()<cr>", "Format file" },
      name = "LSP",
      q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Set Loclist" }
    },
    p = { '"+p', "Paste from clipboard" },
    qc = { "<cmd>lua local input = vim.fn.input('Quick Chat: '); if input ~= '' then require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer }) end<CR>", "CopilotChat - Quick chat" },
    y = { '"+y', "Yank to clipboard" }
  },
  g = {
    e = { "G", "Bottom" },
    h = { "0", "Line start" },
    l = { "$", "Line end" },
    s = { "^", "First non-blank in line" }
  },
  i = {
    ["<C-v>"] = { "<esc>p", "Paste in Insert Mode" }
  },
  v = {
    ["<"] = { "<gv", "Indent Left" },
    ["<C-c>"] = { "y", "Yank Selection" },
    ["<S-TAB>"] = { "<gv", "Indent Left" },
    ["<TAB>"] = { ">gv", "Indent Right" },
    [">"] = { ">gv", "Indent Right" },
    J = { ":m '>+1<CR>gv=gv", "Move Down" },
    K = { ":m '<-2<CR>gv=gv", "Move Up" }
  }
}, { prefix = "" })
