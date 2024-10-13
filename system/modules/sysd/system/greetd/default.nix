{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkMerge mkOption types;
  cfg = config.systemModules.sysd.system.greetd;
in {
  options = {
    systemModules.sysd.system.greetd = {
      enable = mkEnableOption {
        type = types.bool;
        default = false;
        description = "Enables the greetd service.";
      };
      gnomeKeyring.enable = mkEnableOption {
        type = types.bool;
        default = false;
        description = "Enables GnomeKeyring PAM service for greetd.";
      };
      autologin.enable = mkEnableOption {
        type = types.bool;
        default = false;
        description = "Enables autologin for a specified user.";
      };
      autologin.user = mkOption {
        type = types.str;
        default = "cnst";
        description = "The username to auto-login when autologin is enabled.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = mkMerge [
        # Conditionally include initial_session if autologin is enabled
        (mkIf cfg.autologin.enable {
          initial_session = {
            command = "${pkgs.hyprland}/bin/Hyprland";
            user = cfg.autologin.user;
          };
        })
        {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r --remember-session --asterisks";
            user = "greeter";
          };
        }
      ];
    };

    # Apply GnomeKeyring PAM Service based on user configuration
    security.pam.services.greetd.enableGnomeKeyring = cfg.gnomeKeyring.enable;
  };
}
