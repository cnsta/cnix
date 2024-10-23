{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.network.blueman;
in {
  options = {
    nixos.services.network.blueman.enable = mkEnableOption "Enables blueman";
  };
  config = mkIf cfg.enable {
    services = {
      blueman.enable = true;
    };
  };
}
