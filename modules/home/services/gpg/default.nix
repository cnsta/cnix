{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.services.gpg;
in {
  options = {
    home.services.gpg.enable = mkEnableOption "Enables gpg";
  };
  config = mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };
}
