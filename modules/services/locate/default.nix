{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.services.locate;
in
{
  options.cnix.services.locate.enable = mkEnableOption "Enables plocate";

  config = mkIf cfg.enable {
    services.locate = {
      enable = true;
      package = pkgs.plocate;
      interval = "daily";
    };
  };
}
