{
  config,
  lib,
  ...
}: let
  unit = "prowlarr";
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
      default = "Prowlarr";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "PVR indexer";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "prowlarr.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Arr";
    };
  };
  config = lib.mkIf cfg.enable {
    services.${unit} = {
      enable = true;
      # user = srv.user;
      # group = srv.group;
    };
    services.caddy.virtualHosts."${cfg.url}" = {
      useACMEHost = srv.domain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:9696
      '';
    };
    # users.users.prowlarr = {
    #   group = "prowlarr";
    #   isSystemUser = true;
    # };
    # users.groups.prowlarr = {};
  };
}
