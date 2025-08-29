{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.blueman;
in
{
  options = {
    nixos.services.blueman.enable = mkEnableOption "Enables blueman";
  };
  config = mkIf cfg.enable {
    services = {
      blueman.enable = true;
    };
  };
}
