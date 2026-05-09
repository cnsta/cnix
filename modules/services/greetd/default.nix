{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    getExe
    ;

  cfg = config.cnix.services.greetd;
  hyprcfg = config.cnix.programs.hyprland;
  niricfg = config.cnix.programs.niri;
  username = config.cnix.settings.accounts.username;
in
{
  options.cnix.services.greetd.enable = mkEnableOption "greetd display manager";

  config = mkMerge [
    (mkIf cfg.enable {
      services.greetd.enable = true;
    })

    (mkIf (cfg.enable && hyprcfg.enable) (
      let
        session = {
          command = "${getExe config.programs.uwsm.package} start hyprland-uwsm.desktop";
          user = username;
        };
      in
      {
        services.greetd = {
          restart = false;
          settings = {
            terminal.vt = 1;
            default_session = session;
            initial_session = session;
          };
        };
      }
    ))

    (mkIf (cfg.enable && niricfg.enable) (
      let
        session = {
          command = "${getExe pkgs.tuigreet} --time --remember --cmd ${pkgs.niri}/bin/niri-session";
          user = "greeter";
        };
      in
      {
        services.greetd.settings.default_session = session;
      }
    ))
  ];
}
