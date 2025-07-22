{
  config,
  lib,
  ...
}: let
  unit = "lidarr";
  srv = config.server;
  cfg = config.server.${unit};
in {
  options.server.${unit} = {
    enable = lib.mkEnableOption {
      description = "Enable ${unit}";
    };
    configDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/${unit}";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "${unit}.${srv.domain}";
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Lidarr";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Music collection manager";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "lidarr.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
  };
  config = lib.mkIf cfg.enable {
    services.${unit} = {
      enable = true;
    };
    services.caddy.virtualHosts."${cfg.url}" = {
      useACMEHost = srv.domain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:8686
      '';
    };
    users = {
      users.lidarr = {
        uid = 1000;
        group = "lidarr";
        isSystemUser = true;
      };
      groups.lidarr = {
        gid = 1000;
      };
    };
  };
}
