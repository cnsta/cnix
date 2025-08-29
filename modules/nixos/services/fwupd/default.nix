{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.fwupd;
in
{
  options = {
    nixos.services.fwupd.enable = mkEnableOption "Enables fwupd";
  };
  config = mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
