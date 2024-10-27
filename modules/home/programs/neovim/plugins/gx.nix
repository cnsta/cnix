{pkgs, ...}: let
  gx-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "gx-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "chrishrb";
      repo = "gx.nvim";
      rev = "f29a87454b02880e0d76264c21be8316224a7395";
      hash = "sha256-QWJ/cPvSyMTJoWLg51BNFf9+/9i7G+nzennpHP/eQ4g=";
    };
  };
in {
  programs.neovim.plugins = [
    {
      plugin = gx-nvim;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          require("gx").setup({})
          vim.keymap.set({ "n", "x" }, "gx", ":Browse<CR>", {
          	desc = "Open the file under cursor with system app",
          })
        '';
    }
  ];
}
