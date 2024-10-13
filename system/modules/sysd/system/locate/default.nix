{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.sysd.system.locate;
in {
  options = {
    systemModules.sysd.system.locate.enable = mkEnableOption "Enables plocate";
  };
  config = mkIf cfg.enable {
    services.locate = {
      enable = true;
      package = pkgs.plocate;
      localuser = null;
    };
  };
}
