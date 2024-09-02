{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = nvim-treesitter.withAllGrammars;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          require("nvim-treesitter.configs").setup({
          	-- ensure_installed = { "nix", "lua" },
          	highlight = {
          		enable = true,
          		additional_vim_regex_highlighting = false,
          		disable = function(lang, bufnr)
          			return vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr)) > 1048576
          		end,
          	},
          	parser_install_dir = vim.fn.stdpath("data") .. "/parsers",
          })
        '';
    }
  ];
}
