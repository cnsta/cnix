{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = conform-nvim;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          require("conform").setup({
          	default_format_opts = {
          		timeout_ms = 3000,
          		async = false, -- not recommended to change
          		quiet = false, -- not recommended to change
          		lsp_format = "fallback", -- not recommended to change
          	},
          	formatters_by_ft = {
          		bash = { "shfmt" },
          		css = { "prettierd" },
          		html = { "prettierd" },
          		javascript = { "prettierd" },
          		json = { "fixjson" },
          		lua = { "stylua" },
          		nix = { "alejandra" },
          		php = { "php_cs_fixer" },
          		python = { "black" },
          		rust = { "rustfmt" },
          		sh = { "shfmt" },
          		typescript = { "prettierd" },
          		query = { "sql_formatter" },
          		yaml = { "prettierd" },
          		["*"] = { "injected" },
          	},
          })

          -- Optionally, set up a command or auto-command to format on save
          vim.api.nvim_create_autocmd("BufWritePre", {
          	pattern = "*",
          	callback = function()
          		require("conform").format()
          	end,
          })
        '';
    }
  ];
}
