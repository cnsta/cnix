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
      containers.enable = true;
      podman.enable = true;
    };
  };
}
