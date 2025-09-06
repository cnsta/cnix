{
  config,
  lib,
  ...
}:
let
  unit = "syncthing";
  srv = config.server;
  cfg = config.server.${unit};
in
{
  options.server.${unit} = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "${unit}.${srv.domain}";
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Syncthing";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Continuous file synchronization program.";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "syncthing.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
  };
  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [
        8384
        22000
      ];
      allowedUDPPorts = [
        22000
        21027
      ];
    };
    services.${unit} = {
      enable = true;
      user = srv.user;
      guiAddress = "0.0.0.0:8384";
      overrideFolders = false;
      overrideDevices = false;
      dataDir = "/home/${srv.user}/syncthing";
      configDir = "/home/${srv.user}/syncthing/.config/syncting";
    };
    services.caddy.virtualHosts."${cfg.url}" = {
      useACMEHost = srv.domain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:8384
      '';
    };
  };
}
