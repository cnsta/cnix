{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = copilot-lua;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          require("copilot").setup({
          	panel = {
          		enabled = true,
          		auto_refresh = true,
          		keymap = {
          			jump_prev = "[[",
          			jump_next = "]]",
          			accept = "<CR>",
          			refresh = "gr",
          			open = "<M-CR>",
          		},
          		layout = {
          			position = "bottom", -- | top | left | right
          			ratio = 0.4,
          		},
          	},
          	suggestion = {
          		enabled = true,
          		auto_trigger = true,
          		hide_during_completion = true,
          		debounce = 75,
          		keymap = {
          			accept = "<C-CR>",
          			accept_word = false,
          			accept_line = false,
          			next = "<M-]>",
          			prev = "<M-[>",
          			dismiss = "<C-]>",
          		},
          	},
          })
        '';
    }
  ];
}
