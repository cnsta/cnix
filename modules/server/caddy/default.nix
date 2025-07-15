{
  self,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.server.caddy;
in {
  options = {
    server.caddy.enable = mkEnableOption "Enables caddy";
  };
  config = mkIf cfg.enable {
    networking.firewall = let
      ports = [80 443];
    in {
      allowedTCPPorts = ports;
      allowedUDPPorts = ports;
    };

    services.caddy = {
      enable = true;
      # package = self.packages.${pkgs.system}.caddy-with-plugins;
    };
  };
}
