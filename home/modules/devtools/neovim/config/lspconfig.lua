local lspc = require'lspconfig'

-- Setup for LSP servers
lspc.tsserver.setup({
    on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false

        local ts_utils = require("nvim-lsp-ts-utils")
        ts_utils.setup({})
        ts_utils.setup_client(client)

        local buf_map = function(bufnr, mode, lhs, rhs, opts)
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or { silent = true })
        end

        buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
        buf_map(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
        buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")

        -- Custom on_attach functionality
        on_attach(client, bufnr)
    end,
})
lspc.cssls.setup{}
lspc.clangd.setup{}
lspc.tailwindcss.setup{}
lspc.html.setup{}
lspc.astro.setup{}
lspc.phpactor.setup{}
lspc.pyright.setup{}
lspc.marksman.setup{}
lspc.nixd.setup{}
lspc.dockerls.setup{}
lspc.bashls.setup{}
lspc.csharp_ls.setup{}
lspc.yamlls.setup{}
lspc.lua_ls.setup({
})
