{
  config,
  lib,
  ...
}: let
  unit = "uptime-kuma";
  cfg = config.server.${unit};
  srv = config.server;
in {
  options.server.${unit} = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };
    configDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/uptime-kuma";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "uptime.${srv.domain}";
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Uptime Kuma";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Service monitoring tool";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "uptime-kuma.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
  };
  config = lib.mkIf cfg.enable {
    services.${unit} = {
      enable = true;
    };
    services.caddy.virtualHosts."${cfg.url}" = {
      useACMEHost = srv.domain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:3001
      '';
    };
  };
}
