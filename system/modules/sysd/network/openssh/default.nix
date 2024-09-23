{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.network.openssh;
in {
  options = {
    modules.sysd.network.openssh.enable = mkEnableOption "Enables openssh";
  };
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
    };
  };
}
