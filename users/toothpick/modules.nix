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
    browsers = {
      firefox = {
        enable = true;
      };
      chromium = {
        enable = true;
      };
    };
    comm = {
      discord = {
        enable = true;
      };
    };
    devtools = {
      neovim = {
        enable = true;
      };
      vscode = {
        enable = true;
      };
      helix = {
        enable = true;
      };
    };
    gaming = {
      steam = {
        enable = true;
      };
      #   mangohud = {
      #     enable = false;
      #   };
    };
    cli = {
      alacritty = {
        enable = true;
      };
      bash = {
        enable = true;
      };
      foot = {
        enable = true;
      };
      kitty = {
        enable = true;
      };
      wezterm = {
        enable = false;
      };
      zellij = {
        enable = false;
      };
      zsh = {
        enable = true;
      };
    };
    userd = {
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
      mako = {
        enable = true;
      };
      udiskie = {
        enable = true;
      };
      polkit = {
        enable = true;
      };
      syncthing = {
        enable = false;
      };
      xdg = {
        enable = true;
      };
    };
    utils = {
      anyrun = {
        enable = false;
      };
      rofi = {
        enable = false;
      };
      waybar = {
        enable = true;
      };
      yazi = {
        enable = true;
      };
      zathura = {
        enable = false;
      };
      tuirun = {
        enable = true;
      };
      misc = {
        enable = true;
      };
      mpv = {
        enable = true;
      };
      eza = {
        enable = true;
      };
      ssh = {
        enable = true;
      };
    };
    wm = {
      hyprland = {
        cnst = {
          enable = false;
        };
        toothpick = {
          enable = true;
        };
      };
      utils = {
        hypridle = {
          enable = true;
        };
        hyprlock = {
          enable = true;
        };
        hyprpaper = {
          enable = true;
        };
      };
    };
  };
}
