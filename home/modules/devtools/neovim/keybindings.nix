{
  config = {
    programs.neovim = {
      extraLuaConfig =
        /*
        lua
        */
        ''
          -- Key mappings for various commands and navigation
          vim.api.nvim_set_keymap("n", "<C-j>", "<C-e>", { noremap = true })
          vim.api.nvim_set_keymap("n", "<C-k>", "<C-y>", { noremap = true })

          -- Buffers
          vim.api.nvim_set_keymap("n", "<space>b", ":buffers<CR>", { noremap = true })
          vim.api.nvim_set_keymap("n", "<C-l>", ":bnext<CR>", { noremap = true })
          vim.api.nvim_set_keymap("n", "<C-h>", ":bprev<CR>", { noremap = true })
          vim.api.nvim_set_keymap("n", "<C-q>", ":bdel<CR>", { noremap = true })

          -- Navigation
          vim.api.nvim_set_keymap("n", "<space>e", ":e<space>", { noremap = true })
          vim.api.nvim_set_keymap("n", "<space>E", ":e %:h<tab>", { noremap = true })
          vim.api.nvim_set_keymap("n", "<space>c", ":cd<space>", { noremap = true })
          vim.api.nvim_set_keymap("n", "<space>C", ":cd %:h<tab>", { noremap = true })

          -- Loclist
          vim.api.nvim_set_keymap("n", "<space>l", ":lwindow<cr>", { noremap = true })
          vim.api.nvim_set_keymap("n", "[l", ":lprev<cr>", { noremap = true })
          vim.api.nvim_set_keymap("n", "]l", ":lnext<cr>", { noremap = true })
          vim.api.nvim_set_keymap("n", "<space>L", ":lhistory<cr>", { noremap = true })
          vim.api.nvim_set_keymap("n", "[L", ":lolder<cr>", { noremap = true })
          vim.api.nvim_set_keymap("n", "]L", ":lnewer<cr>", { noremap = true })

          -- Quickfix
          vim.api.nvim_set_keymap("n", "<space>q", ":cwindow<cr>", { noremap = true })
          vim.api.nvim_set_keymap("n", "[q", ":cprev<cr>", { noremap = true })
          vim.api.nvim_set_keymap("n", "]q", ":cnext<cr>", { noremap = true })
          vim.api.nvim_set_keymap("n", "<space>Q", ":chistory<cr>", { noremap = true })
          vim.api.nvim_set_keymap("n", "[Q", ":colder<cr>", { noremap = true })
          vim.api.nvim_set_keymap("n", "]Q", ":cnewer<cr>", { noremap = true })

          -- Make
          vim.api.nvim_set_keymap("n", "<space>m", ":make<cr>", { noremap = true })

          -- Grep (replace with ripgrep)
          vim.api.nvim_set_keymap("n", "<space>g", ":grep<space>", { noremap = true })
          if vim.fn.executable("rg") == 1 then
          	vim.opt.grepprg = "rg --vimgrep"
          	vim.opt.grepformat = "%f:%l:%c:%m"
          end

          -- Close other splits
          vim.api.nvim_set_keymap("n", "<space>o", ":only<cr>", { noremap = true })

          -- Sudo save
          vim.api.nvim_set_keymap("c", "w!!", "w !sudo tee > /dev/null %", { noremap = true })

          -- Other utility key mappings
          vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })
          vim.keymap.set("n", "<C-v>", "p", { desc = "Paste" })
          vim.keymap.set("i", "<C-v>", "<esc>p", { desc = "Paste" })
          vim.keymap.set("v", "<C-c>", "y", { desc = "Yank" })

          -- LSP-related mappings
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
          vim.keymap.set("n", "<space>a", vim.lsp.buf.code_action, { desc = "Code action" })

          -- Diagnostics
          vim.keymap.set("n", "<space>d", vim.diagnostic.open_float, { desc = "Floating diagnostic" })
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
          vim.keymap.set("n", "gl", vim.diagnostic.setloclist, { desc = "Diagnostics on loclist" })
          vim.keymap.set("n", "gq", vim.diagnostic.setqflist, { desc = "Diagnostics on quickfix" })
        '';
    };
  };
}
