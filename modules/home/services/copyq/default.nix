{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.services.copyq;
in {
  options = {
    home.services.copyq.enable = mkEnableOption "Enables copyq";
  };
  config = mkIf cfg.enable {
    services.copyq = {
      enable = true;
    };
  };
}
