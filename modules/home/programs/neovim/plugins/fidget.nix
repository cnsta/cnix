{ pkgs, ... }:
{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = fidget-nvim;
      type = "lua";
      config =
        # lua
        ''
          require("fidget").setup({
          	progress = {
          		display = {
          			progress_icon = { pattern = "dots", period = 1 },
          		},
          	},
          })
        '';
    }
  ];
}
