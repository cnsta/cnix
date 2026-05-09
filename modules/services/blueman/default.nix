{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.services.blueman;
in
{
  options.cnix.services.blueman.enable = mkEnableOption "Enables blueman";

  config = mkIf cfg.enable {
    services = {
      blueman.enable = true;
    };
  };
}
