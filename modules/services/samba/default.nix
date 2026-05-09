{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.services.samba;
in
{
  options.cnix.services.samba.enable = mkEnableOption "Enables samba";

  config = mkIf cfg.enable {
    services = {
      samba = {
        enable = true;
        package = pkgs.samba4Full;
        openFirewall = true;
      };
      avahi = {
        publish.enable = true;
        publish.userServices = true;
        enable = true;
        openFirewall = true;
      };
      samba-wsdd = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
