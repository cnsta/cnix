{lib, ...}: let
  inherit (lib) mkForce;
in {
  monitors = [
    {
      name = mkForce "eDP-1";
      width = mkForce 1920;
      height = mkForce 1200;
      refreshRate = mkForce 60;
      # workspace = "1";
      # primary = true;
    }
  ];
  home = {
    #     browsers = {
    #       firefox = {
    #         enable = true;
    #       };
    #       chromium = {
    #         enable = false;
    #       };
    #     };
    #     comm = {
    #       discord = {
    #         enable = true;
    #       };
    #     };
    #     devtools = {
    #       neovim = {
    #         enable = true;
    #       };
    #       vscode = {
    #         enable = false;
    #       };
    #       helix = {
    #         enable = true;
    #       };
    #     };
    gaming = {
      steam = {
        enable = mkForce false;
      };
      #   mangohud = {
      #     enable = false;
      #   };
    };
    #     terminal = {
    #       alacritty = {
    #         enable = true;
    #       };
    #       foot = {
    #         enable = true;
    #       };
    #       kitty = {
    #         enable = true;
    #       };
    #       wezterm = {
    #         enable = false;
    #       };
    #       zellij = {
    #         enable = false;
    #       };
    #     };
    #     userd = {
    #       blueman-applet = {
    #         enable = true;
    #       };
    #       copyq = {
    #         enable = true;
    #       };
    #       gpg = {
    #         enable = false;
    #       };
    #       mako = {
    #         enable = true;
    #       };
    #       udiskie = {
    #         enable = true;
    #       };
    #       syncthing = {
    #         enable = true;
    #       };
    #     };
    #     utils = {
    #       anyrun = {
    #         enable = false;
    #       };
    #       rofi = {
    #         enable = false;
    #       };
    #       waybar = {
    #         enable = true;
    #       };
    #       yazi = {
    #         enable = true;
    #       };
    #       zathura = {
    #         enable = true;
    #       };
    #       tuirun = {
    #         enable = true;
    #       };
    #       misc = {
    #         enable = true;
    #       };
    #       mpv = {
    #         enable = true;
    #       };
    #       eza = {
    #         enable = true;
    #       };
    #       ssh = {
    #         enable = true;
    #       };
    #     };
    #     wm = {
    #       hyprland = {
    #         cnst = {
    #           enable = true;
    #         };
    #         toothpick = {
    #           enable = false;
    #         };
    #       };
    #       utils = {
    #         hypridle = {
    #           enable = true;
    #         };
    #         hyprlock = {
    #           enable = true;
    #         };
    #         hyprpaper = {
    #           enable = true;
    #         };
    #       };
    #     };
  };
}
