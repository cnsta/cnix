{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.userd.copyq;
in {
  options = {
    modules.userd.copyq.enable = mkEnableOption "Enables copyq";
  };
  config = mkIf cfg.enable {
    services.copyq = {
      enable = true;
    };
  };
}
