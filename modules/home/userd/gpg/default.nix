{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.userd.gpg;
in {
  options = {
    home.userd.gpg.enable = mkEnableOption "Enables gpg";
  };
  config = mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };
}
