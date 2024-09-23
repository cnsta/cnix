{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.userd.gpg;
in {
  options = {
    modules.userd.gpg.enable = mkEnableOption "Enables gpg";
  };
  config = mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };
}
