{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.sysd.network.openssh;
in {
  options = {
    systemModules.sysd.network.openssh.enable = mkEnableOption "Enables openssh";
  };
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
    };
  };
}
