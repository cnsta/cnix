{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.userModules.userd.copyq;
in {
  options = {
    userModules.userd.copyq.enable = mkEnableOption "Enables copyq";
  };
  config = mkIf cfg.enable {
    services.copyq = {
      enable = true;
    };
  };
}
