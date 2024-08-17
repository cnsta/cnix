{
  modules = {
    wm = {
      hyprland = {
        cnst.enable = true;
        # toothpick.enable = false;
        # adam.enable = false;
      };
      utils = {
        hypridle.enable = true;
        hyprlock.enable = true;
        hyprpaper.enable = true;
      };
    };
    browsers = {
      firefox.enable = true;
      chromium.enable = false;
    };
    devtools = {
      neovim.enable = true;
      vscode.enable = false;
    };
    comm = {
      discord.enable = true;
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
    utils = {
      ags.enable = false;
      anyrun.enable = false;
      rofi.enable = false;
      waybar.enable = true;
      yazi.enable = true;
    };
    userd = {
      sops.enable = true;
      copyq.enable = true;
      mako.enable = true;
      udiskie.enable = true;
    };
  };
}
