{ pkgs, ... }:
{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = comment-nvim;
      type = "lua";
      config =
        # lua
        ''
          require("Comment").setup({
          	opleader = {
          		line = "<C-b>",
          	},
          	toggler = {
          		line = "<C-b>",
          	},
          })
        '';
    }
  ];
}
