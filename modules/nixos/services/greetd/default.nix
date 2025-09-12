{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    mkMerge
    ;
  cfg = config.nixos.services.greetd;
  hyprcfg = config.nixos.programs.hyprland;
  niricfg = config.nixos.programs.niri;
in
{
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

  config =
    let
      usernames = builtins.attrNames config.home-manager.users;
      username = builtins.head usernames;
    in
    mkMerge [
      (mkIf cfg.enable { services.greetd.enable = true; })

      (mkIf hyprcfg.enable {
        services.greetd =
          let
            session = {
              command = "${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop";
              user = cfg.user;
            };
          in
          {
            settings = {
              terminal.vt = 1;
              default_session = session;
              initial_session = session;
            };
          };
      })

      (mkIf niricfg.enable {
        services.greetd = {
          enable = true;
          settings = rec {
            tuigreet_session =
              let
                session = "${pkgs.niri-unstable}/bin/niri-session";
                tuigreet = "${lib.getExe pkgs.tuigreet}";
              in
              {
                command = "${tuigreet} --time --remember --cmd ${session}";
                user = "greeter";
              };
            default_session = tuigreet_session;
          };
        };
      })
    ];
}
