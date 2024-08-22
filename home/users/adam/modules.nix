{
  modules = {
    browsers = {
      firefox.enable = true;
      chromium.enable = false;
    };
    comm = {
      discord.enable = true;
    };
    devtools = {
      nixvim = {
        enable = true;
        plugins = {
          ai.enable = false;
          barbar.enable = true;
          comment.enable = true;
          conform-nvim.enable = true;
          efm.enable = true;
          floaterm.enable = false;
          harpoon.enable = false;
          lsp.enabe = true;
          lualine.enable = true;
          markdown-preview.enable = true;
          neo-tree.enable = true;
          none-ls.enable = true;
          startify.enable = true;
          tagbar.enable = false;
          telescope.enable = true;
          treesitter.enable = true;
          vimtex.enable = false;
          yanky.enable = false;
        };
      };
      vscode.enable = false;
    };
    gaming = {
      lutris.enable = false;
      mangohud.enable = false;
    };
    terminal = {
      alacritty.enable = true;
      foot.enable = true;
      kitty.enable = true;
      zellij.enable = false;
    };
    userd = {
      sops = {
        enable = false;
        adam = false;
      };
      copyq.enable = true;
      mako.enable = true;
      udiskie.enable = true;
    };
    utils = {
      ags.enable = false;
      anyrun.enable = false;
      rofi.enable = false;
      waybar.enable = true;
      yazi.enable = true;
      misc.enable = true;
    };
    wm = {
      hyprland = {
        cnst.enable = false;
        toothpick.enable = false;
        adam.enable = true;
      };
      utils = {
        hypridle.enable = true;
        hyprlock.enable = true;
        hyprpaper.enable = true;
      };
    };
  };
}
