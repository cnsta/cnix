{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.sysd.network.openssh;
in {
  options = {
    system.sysd.network.openssh.enable = mkEnableOption "Enables openssh";
  };
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
    };
  };
}
