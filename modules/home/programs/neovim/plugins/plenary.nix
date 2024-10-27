{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = plenary-nvim;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          require("plenary").setup({})
        '';
    }
  ];
}
