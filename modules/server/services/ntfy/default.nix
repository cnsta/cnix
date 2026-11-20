{
  config,
  lib,
  clib,
  self,
  ...
}: let
  unit = "ntfy";
  cfg = config.cnix.server.services.${unit};
in {
  config = lib.mkIf cfg.enable {
    age.secrets.ntfyEnvironment = {
      file = self + "/secrets/ntfyEnvironment.age";
      mode = "0400";
    };

    services.ntfy-sh = {
      enable = true;
      environmentFile = config.age.secrets.ntfyEnvironment.path;
      settings = {
        base-url = "https://${clib.server.mkFullDomain config cfg}";
        listen-http = "127.0.0.1:${toString cfg.port}";
        behind-proxy = true;
        auth-default-access = "deny-all";
        enable-login = true;
        visitor-request-limit-exempt-hosts = "10.88.0.0/16";
      };
    };
  };
}
