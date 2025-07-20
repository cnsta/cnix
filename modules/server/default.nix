{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.server;
in {
  options.server = {
    email = mkOption {
      default = "";
      type = types.str;
      description = ''
        Email name to be used to access the server services via Caddy reverse proxy
      '';
    };
    domain = mkOption {
      default = "";
      type = types.str;
      description = ''
        Domain name to be used to access the server services via Caddy reverse proxy
      '';
    };
    user = lib.mkOption {
      default = "share";
      type = lib.types.str;
      description = ''
        User to run the homelab services as
      '';
    };
    group = lib.mkOption {
      default = "share";
      type = lib.types.str;
      description = ''
        Group to run the homelab services as
      '';
    };
    timeZone = lib.mkOption {
      default = "Europe/Stockholm";
      type = lib.types.str;
      description = ''
        Time zone to be used for the homelab services
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    users = {
      groups.${cfg.group} = {
        gid = 993;
      };
      users.${cfg.user} = {
        uid = 994;
        isSystemUser = true;
        group = cfg.group;
      };
    };
  };
}
