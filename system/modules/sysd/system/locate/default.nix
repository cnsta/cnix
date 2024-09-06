{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.system.locate;
in {
  options = {
    modules.sysd.system.locate.enable = mkEnableOption "Enables plocate";
  };
  config = mkIf cfg.enable {
    services.locate = {
      enable = true;
      package = pkgs.plocate;
      localuser = null;
    };
  };
}
