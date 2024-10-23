{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.system.locate;
in {
  options = {
    nixos.services.system.locate.enable = mkEnableOption "Enables plocate";
  };
  config = mkIf cfg.enable {
    services.locate = {
      enable = true;
      package = pkgs.plocate;
      localuser = null;
    };
  };
}
