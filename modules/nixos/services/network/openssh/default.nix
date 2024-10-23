{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.network.openssh;
in {
  options = {
    nixos.services.network.openssh.enable = mkEnableOption "Enables openssh";
  };
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
    };
  };
}
