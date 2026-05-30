{
  config,
  lib,
  ...
}:
let
  infra = config.cnix.server.infra;
in
{
  options.cnix.server.infra = {
    podman.enable = lib.mkEnableOption "Enables Podman";
  };
  config = lib.mkIf infra.podman.enable {
    networking.firewall.trustedInterfaces = [ "podman0" ];
    virtualisation = {
      podman = {
        enable = true;
        autoPrune.enable = true;
      };
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
