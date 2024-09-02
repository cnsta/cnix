{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = range-highlight-nvim;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          require('range-highlight').setup{}
        '';
    }
  ];
}
