{
  monitors = [
    {
      name = "DVI-D-1";
      width = 1920;
      height = 1080;
      refreshRate = 144;
      workspace = "1";
      primary = true;
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
        enable = false;
      };
      ssh = {
        enable = true;
      };
      tuirun = {
        enable = true;
      };
      vscodium = {
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
        enable = false;
      };
      copyq = {
        enable = true;
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
      syncthing = {
        enable = false;
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
