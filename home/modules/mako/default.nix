{ pkgs, ... }:
{
  home.packages = [ pkgs.libnotify ];

  services.mako = {
    enable = true;
    iconPath = "$HOME/.nix-profile/share/icons/Gruvbox-Plus-Dark";
    font = "FiraCode Nerd Font Medium 12";
    padding = "10";
    margin = "10";
    anchor = "bottom-right";
    width = 400;
    height = 150;
    borderSize = 2;
    defaultTimeout = 12000;
    backgroundColor = "#3c3836dd";
    borderColor = "#689d6add";
    textColor = "#d5c4a1dd";
    layer = "overlay";
    extraConfig = ''
      max-history=50
      outer-margin=25
      icon-location=right
    '';
  };
}
