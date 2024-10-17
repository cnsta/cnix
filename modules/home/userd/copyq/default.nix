{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.userd.copyq;
in {
  options = {
    home.userd.copyq.enable = mkEnableOption "Enables copyq";
  };
  config = mkIf cfg.enable {
    services.copyq = {
      enable = true;
    };
  };
}
