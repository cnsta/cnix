{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.userd.mako;
in {
  options = {
    home.userd.mako.enable = mkEnableOption "Enables mako";
  };
  config = mkIf cfg.enable {
    services.mako = {
      enable = true;
      iconPath = "$HOME/.nix-profile/share/icons/Gruvbox-Plus-Dark";
      font = "FiraCode Nerd Font Medium 12";
      padding = "20";
      margin = "10";
      anchor = "top-right";
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
        max-visible=4
        outer-margin=25
        icon-location=right
        max-icon-size=48
        [mode=do-not-disturb]
        invisible=1
      '';
    };
  };
}
