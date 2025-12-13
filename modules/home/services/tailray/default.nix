{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.services.tailray;
in
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
    systemd.user.services.tailray.Unit.After = lib.mkForce "tailscaled.service";
  };
}
