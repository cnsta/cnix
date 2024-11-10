{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkMerge mkOption types;
  cfg = config.nixos.services.greetd;
in {
  options = {
    nixos.services.greetd = {
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
      user = mkOption {
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
            command = "${lib.getExe config.programs.hyprland.package}";
            user = cfg.user;
          };
        })
        {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --window-padding 1 --time --time-format '%R - %F' -r --remember-session --asterisks";
            user = cfg.user;
          };
        }
      ];
    };

    # Apply GnomeKeyring PAM Service based on user configuration
    security.pam.services.greetd.enableGnomeKeyring = cfg.gnomeKeyring.enable;
  };
}
