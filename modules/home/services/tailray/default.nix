{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.home.services.tailray;
in
with lib;
{
  imports = [
    inputs.tailray.homeManagerModules.default
  ];
  options = {
    home.services.tailray.enable = mkEnableOption "Enables tailray";
  };
  config = mkIf cfg.enable {
    services.tailray = {
      enable = true;
    };
    systemd.user.services.tailray = {
      Unit.After = lib.mkForce "graphical-session.target";
      Service = {
        ExecStartPre = "/run/current-system/sw/bin/sleep 5";
      };
    };
  };
}
