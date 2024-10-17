{pkgs, ...}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      none-ls-nvim
      plenary-nvim
      nvim-treesitter.withAllGrammars
    ];
    extraConfig =
      /*
      lua
      */
      ''
        -- Require necessary plugins
        require("plenary")
        require("nvim-treesitter.configs").setup({
        	highlight = {
        		enable = true,
        	},
        	indent = {
        		enable = true,
        	},
        })

        local null_ls = require("null-ls")

        -- Setup null-ls with stylua and other formatters
        null_ls.setup({
        	sources = {
        		null_ls.builtins.formatting.alejandra,
        		null_ls.builtins.formatting.stylua,
        		null_ls.builtins.formatting.black,
        		null_ls.builtins.formatting.isort,
        		null_ls.builtins.formatting.phpcsfixer,
        		null_ls.builtins.formatting.pint,
        		null_ls.builtins.formatting.prettier,
        		null_ls.builtins.formatting.sql_formatter,
        		null_ls.builtins.formatting.xmllint,
        		null_ls.builtins.formatting.shfmt,
        	},
        })

        -- Function to format on save
        local function format_on_save()
        	vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format({ async = true })]])
        end

        -- Call the function to enable auto format on save
        format_on_save()
      '';
  };
}
