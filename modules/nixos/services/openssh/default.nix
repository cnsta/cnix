{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.openssh;
in {
  options = {
    nixos.services.openssh.enable = mkEnableOption "Enables openssh";
  };
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
    };
  };
}
