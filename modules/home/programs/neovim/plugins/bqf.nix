{ pkgs, ... }:
{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = nvim-bqf;
      type = "lua";
      config =
        # lua
        ''
          require("bqf").setup({})
        '';
    }
  ];
}
