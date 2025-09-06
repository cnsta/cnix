{
  config,
  lib,
  ...
}:
let
  unit = "syncthing";
  srv = config.server;
  cfg = config.server.${unit};
  dir = [
    "${srv.mounts.config}/syncthing"
  ];
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
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 share share - -") dir;
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
      group = srv.group;
      overrideFolders = false;
      overrideDevices = false;
      dataDir = "${srv.mounts.fast}/Syncthing";
      configDir = "${srv.mounts.config}/syncthing";
    };
    services.caddy.virtualHosts."${cfg.url}" = {
      useACMEHost = srv.domain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:8384
      '';
    };
  };
}
