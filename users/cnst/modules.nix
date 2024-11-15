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
      };
      eza = {
        enable = true;
      };
      firefox = {
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
      ironbar = {
        enable = false;
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
      nwg-bar = {
        enable = true;
      };
      rofi = {
        enable = false;
      };
      ssh = {
        enable = true;
      };
      tuirun = {
        enable = true;
      };
      vscode = {
        enable = false;
      };
      waybar = {
        enable = true;
      };
      wezterm = {
        enable = false;
      };
      yazi = {
        enable = false;
      };
      zathura = {
        enable = true;
      };
      zellij = {
        enable = false;
      };
      zen = {
        enable = true;
      };
      zsh = {
        enable = true;
      };
    };
    services = {
      blueman-applet = {
        enable = true;
      };
      copyq = {
        enable = false;
      };
      dconf = {
        settings = {
          color-scheme = "prefer-dark";
        };
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
        enable = true;
      };
      polkit = {
        enable = true;
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
