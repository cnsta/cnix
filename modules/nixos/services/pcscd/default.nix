{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.pcscd;
in {
  options = {
    nixos.services.pcscd.enable = mkEnableOption "Enables pcscd";
  };
  config = mkIf cfg.enable {
    services.pcscd.enable = true;
  };
}
