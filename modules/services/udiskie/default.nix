{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe';
  cfg = config.cnix.services.udiskie;
in {
  options.cnix.services.udiskie.enable = mkEnableOption "udiskie automounter";

  config = mkIf cfg.enable {
    systemd.user.services.udiskie = {
      description = "udiskie mount daemon";
      requires = ["tray.target"];
      after = [
        "graphical-session.target"
        "tray.target"
      ];
      partOf = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];

      serviceConfig.ExecStart = getExe' pkgs.udiskie "udiskie";
    };
  };
}
