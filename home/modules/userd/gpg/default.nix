{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.userModules.userd.gpg;
in {
  options = {
    userModules.userd.gpg.enable = mkEnableOption "Enables gpg";
  };
  config = mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };
}
