{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.services.dunst;
in {
  options = {
    home.services.dunst.enable = mkEnableOption "Enables dunst";
  };
  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus";
      };
      settings = {
        global = {
          browser = "${config.home.sessionVariables.BROWSER}";
          padding = 16;
          horizontal_padding = 16;
          font = "Input Sans Compressed Light 12";
          frame_color = "#4c7a5d";
          separator_color = "#504945";
        };
        urgency_low = {
          msg_urgency = "low";
          background = "#665c54";
          foreground = "#d5c4a1";
        };
        urgency_normal = {
          msg_urgency = "normal";
          background = "#3c3836";
          foreground = "#d5c4a1";
          # foreground = "#fbf1c7";
        };
        urgency_critical = {
          msg_urgency = "critical";
          background = "#282828";
          foreground = "#c14a4a";
        };
      };
    };
  };
}
