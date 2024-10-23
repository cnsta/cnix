{lib, ...}: let
  inherit (lib) mkForce;
in {
  # monitors = [
  #   {
  #     name = "DP-3";
  #     width = 2560;
  #     height = 1440;
  #     refreshRate = 240;
  #     bitDepth = 10;
  #     workspace = "1";
  #     primary = true;
  #   }
  #   {
  #     name = "eDP-1";
  #     width = 1920;
  #     height = 1200;
  #     refreshRate = 60;
  #     workspace = "1";
  #     primary = false;
  #   }
  # ];
  home = {
    #   browsers = {
    #     firefox = {
    #       enable = true;
    #     };
    #     chromium = {
    #       enable = false;
    #     };
    #     zen = {
    #       enable = true;
    #   };
    # };
    # comm = {
    #   discord = {
    #     enable = true;
    #   };
    # };
    # devtools = {
    #   neovim = {
    #     enable = true;
    #   };
    #   vscode = {
    #     enable = false;
    #   };
    #   helix = {
    #     enable = true;
    #   };
    # };
    gaming = {
      steam = {
        enable = mkForce false;
      };
      #   mangohud = {
      #     enable = true;
      #   };
      lutris = {
        enable = mkForce false;
      };
    };
    # cli = {
    #   alacritty = {
    #     enable = true;
    #   };
    #   bash = {
    #     enable = true;
    #   };
    #   foot = {
    #     enable = true;
    #   };
    #   jujutsu = {
    #     enable = false;
    #   };
    #   kitty = {
    #     enable = true;
    #   };
    #   wezterm = {
    #     enable = false;
    #   };
    #   zellij = {
    #     enable = false;
    #   };
    #   zsh = {
    #     enable = true;
    #   };
    # };
    # userd = {
    #   blueman-applet = {
    #     enable = true;
    #   };
    #   copyq = {
    #     enable = true;
    #   };
    #   dconf = {
    #   settings = {
    #     color-scheme = "prefer-dark";
    #   };
    # };
    # gpg = {
    #   enable = false;
    # };
    # gtk = {
    #   enable = true;
    # };
    # mako = {
    #   enable = true;
    # };
    # udiskie = {
    #   enable = true;
    # };
    # polkit = {
    #   enable = true;
    # };
    # syncthing = {
    #   enable = true;
    # };
    # xdg = {
    #   enable = true;
    #   };
    # };
    # utils = {
    #   anyrun = {
    #     enable = false;
    #   };
    #   rofi = {
    #     enable = false;
    #   };
    #   waybar = {
    #     enable = true;
    #   };
    #   yazi = {
    #     enable = true;
    #   };
    #   zathura = {
    #     enable = true;
    #   };
    #   tuirun = {
    #     enable = true;
    #   };
    #   misc = {
    #     enable = true;
    #   };
    #   mpv = {
    #     enable = true;
    #   };
    #   eza = {
    #     enable = true;
    #   };
    #   ssh = {
    #     enable = true;
    #   };
    # };
    # wm = {
    #   hyprland = {
    #     cnst = {
    #       enable = true;
    #     };
    #     toothpick = {
    #       enable = false;
    #     };
    #   };
    #   utils = {
    #     hypridle = {
    #       enable = true;
    #     };
    #     hyprlock = {
    #       enable = true;
    #     };
    #     hyprpaper = {
    #       enable = true;
    #     };
    #   };
    # };
  };
}
