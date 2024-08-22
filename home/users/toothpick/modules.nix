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
          lualine.enable = true;
          markdown-preview.enable = true;
          neo-tree.enable = true;
          none-ls.enable = true;
          startify.enable = true;
          telescope.enable = true;
          treesitter.enable = true;
          floaterm.enable = false;
          harpoon.enable = false;
          tagbar.enable = false;
          vimtex.enable = false;
          yanky.enable = false;
          rustaceanvim.enable = true;
          lsp.enable = true;
        };
      };
      vscode.enable = true;
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
        toothpick = false;
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
        toothpick.enable = true;
        adam.enable = false;
      };
      utils = {
        hypridle.enable = true;
        hyprlock.enable = true;
        hyprpaper.enable = true;
      };
    };
  };
}
