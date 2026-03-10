{
  config,
  lib,
  ...
}:
let
  infra = config.server.infra;
in
{
  options.server.infra = {
    podman.enable = lib.mkEnableOption "Enables Podman";
  };
  config = lib.mkIf infra.podman.enable {
    virtualisation = {
      podman.enable = true;
      containers = {
        enable = true;
        containersConf.settings = {
          network = {
            dns_bind_port = 5353;
          };
        };
      };
    };
  };
}
