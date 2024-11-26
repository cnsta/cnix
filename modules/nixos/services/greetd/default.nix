{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkMerge mkOption types;
  cfg = config.nixos.services.greetd;
  host = config.networking.hostName;
in {
  options = {
    nixos.services.greetd = {
      enable = mkEnableOption {
        type = types.bool;
        default = false;
        description = "Enables the greetd service.";
      };
      user = mkOption {
        type = types.str;
        default = "cnst";
        description = "The username to auto-login when autologin is enabled.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.greetd = let
      session = {
        command = "${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop";
        user = cfg.user;
      };
    in {
      enable = true;
      settings = {
        terminal.vt = 1;
        default_session = session;
        initial_session = session;
      };
    };

    programs.uwsm = {
      enable = true;
      waylandCompositors.hyprland = {
        binPath = "/run/current-system/sw/bin/Hyprland";
        prettyName = "Hyprland";
        comment = "Hyprland managed by UWSM";
      };
    };

    #   (mkIf (host == "cnix" || host == "cnixpad") {
    #     programs.uwsm = {
    #       enable = true;
    #       waylandCompositors.hyprland = {
    #         binPath = "/etc/profiles/per-user/cnst/bin/Hyprland";
    #         prettyName = "Hyprland";
    #         comment = "Hyprland managed by UWSM";
    #       };
    #     };
    #   })

    #   (mkIf (host == "toothpc") {
    #     programs.uwsm = {
    #       enable = true;
    #       waylandCompositors.hyprland = {
    #         binPath = "/etc/profiles/per-user/toothpick/bin/Hyprland";
    #         prettyName = "Hyprland";
    #         comment = "Hyprland managed by UWSM";
    #       };
    #     };
    #   })
    #   # Apply GnomeKeyring PAM Service based on user configuration
    #   # security.pam.services.greetd.enableGnomeKeyring = cfg.gnomeKeyring.enable;
    # ]);
  };
}
