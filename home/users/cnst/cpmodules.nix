{lib, ...}: let
  inherit (lib) mkForce;
in {
  modules = {
    # browsers = {
    #   firefox = {
    #     enable = mkForce true;
    #   };
    #   chromium = {
    #     enable = mkForce true;
    #   };
    # };
    # comm = {
    #   discord = {
    #     enable = mkForce true;
    #   };
    # };
    # devtools = {
    #   neovim = {
    #     enable = mkForce true;
    #   };
    #   vscode = {
    #     enable = mkForce false;
    #   };
    #   helix = {
    #     enable = mkForce true;
    #   };
    # };
    # gaming = {
    #   lutris = {
    #     enable = mkForce false;
    #   };
    #   mangohud = {
    #     enable = mkForce false;
    #   };
    # };
    # terminal = {
    #   alacritty = {
    #     enable = mkForce true;
    #   };
    #   foot = {
    #     enable = mkForce true;
    #   };
    #   kitty = {
    #     enable = mkForce true;
    #   };
    #   wezterm = {
    #     enable = mkForce true;
    #   };
    #   zellij = {
    #     enable = mkForce false;
    #   };
    # };
    # userd = {
    #   copyq = {
    #     enable = mkForce true;
    #   };
    #   mako = {
    #     enable = mkForce true;
    #   };
    #   udiskie = {
    #     enable = mkForce true;
    #   };
    # };
    # utils = {
    #   anyrun = {
    #     enable = mkForce false;
    #   };
    #   rofi = {
    #     enable = mkForce false;
    #   };
    #   waybar = {
    #     enable = mkForce true;
    #   };
    #   yazi = {
    #     enable = mkForce true;
    #   };
    #   zathura = {
    #     enable = mkForce true;
    #   };
    #   misc = {
    #     enable = mkForce true;
    #   };
    # };
    # wm = {
    #   hyprland = {
    #     cnst = {
    #       enable = mkForce true;
    #     };
    #     toothpick = {
    #       enable = mkForce false;
    #     };
    #   };
    #   utils = {
    #     hypridle = {
    #       enable = mkForce true;
    #     };
    #     hyprlock = {
    #       enable = mkForce true;
    #     };
    #     hyprpaper = {
    #       enable = mkForce true;
    #     };
    #   };
    # };
  };
}
