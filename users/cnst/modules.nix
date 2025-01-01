{
  monitors = [
    {
      name = "DP-3";
      width = 2560;
      height = 1440;
      refreshRate = 240;
      bitDepth = 10;
      workspace = "1";
      primary = true;
    }
    {
      name = "eDP-1";
      width = 1920;
      height = 1200;
      refreshRate = 60;
      workspace = "1";
      primary = false;
    }
  ];
  home = {
    programs = {
      aerc = {
        enable = false;
      };
      alacritty = {
        enable = true;
      };
      anyrun = {
        enable = false;
      };
      bash = {
        enable = true;
      };
      chromium = {
        enable = true;
      };
      discord = {
        enable = true;
        variant = "canary";
      };
      eza = {
        enable = true;
      };
      floorp = {
        enable = true;
      };
      firefox = {
        enable = true;
      };
      fish = {
        enable = true;
      };
      foot = {
        enable = true;
      };
      helix = {
        enable = true;
      };
      hyprland = {
        enable = true;
      };
      hyprlock = {
        enable = true;
      };
      jujutsu = {
        enable = false;
      };
      kitty = {
        enable = true;
      };
      misc = {
        enable = true;
      };
      mpv = {
        enable = true;
      };
      neovim = {
        enable = false;
      };
      nvf = {
        enable = true;
      };
      nwg-bar = {
        enable = true;
      };
      rofi = {
        enable = true;
      };
      ssh = {
        enable = true;
      };
      tuirun = {
        enable = true;
      };
      vscode = {
        enable = true;
      };
      waybar = {
        enable = true;
      };
      wezterm = {
        enable = false;
      };
      yazi = {
        enable = true;
      };
      zathura = {
        enable = true;
      };
      zed-editor = {
        enable = true;
      };
      zellij = {
        enable = false;
      };
      zen = {
        enable = true;
      };
      zsh = {
        enable = false;
      };
    };
    services = {
      blueman-applet = {
        enable = false;
      };
      copyq = {
        enable = false;
      };
      dconf = {
        settings = {
          color-scheme = "prefer-dark";
        };
      };
      dunst = {
        enable = true;
      };
      gpg = {
        enable = false;
      };
      gtk = {
        enable = true;
      };
      hypridle = {
        enable = true;
      };
      hyprpaper = {
        enable = true;
      };
      mako = {
        enable = false;
      };
      protonmail-bridge = {
        enable = true;
      };
      swaync = {
        enable = false;
      };
      syncthing = {
        enable = true;
      };
      udiskie = {
        enable = true;
      };
      xdg = {
        enable = true;
      };
    };
  };
}
