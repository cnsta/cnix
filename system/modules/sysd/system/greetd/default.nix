{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.system.greetd;
in {
  options = {
    modules.sysd.system.greetd.enable = mkEnableOption "Enables greetd";
  };
  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        # AUTOLOGIN
        # initial_session = {
        #   command = "${pkgs.hyprland}/bin/Hyprland";
        #   user = "cnst"; # <- select which user to auto-login
        # };
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r --remember-session --asterisks";
          user = "greeter";
        };
      };
    };
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
