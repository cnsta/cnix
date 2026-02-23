{
  config,
  lib,
  self,
  ...
}:
let
  infra = config.server.infra;
in
{
  options.server.infra = {
    gluetun.enable = lib.mkEnableOption "Enables gluetun";
  };
  config = lib.mkIf infra.gluetun.enable {
    age.secrets.gluetunEnvironment.file = "${self}/secrets/gluetunEnvironment.age";

    virtualisation.oci-containers.containers.gluetun = {
      image = "ghcr.io/qdm12/gluetun:latest";
      ports = [
        "8388:8388"
        "58846:58846"
        "8080:8080"
        "5030:5030"
        "5031:5031"
        "50300:50300"
      ];
      devices = [ "/dev/net/tun:/dev/net/tun" ];
      autoStart = true;
      extraOptions = [
        "--cap-add=NET_ADMIN"
      ];
      volumes = [ "/var:/gluetun" ];
      environmentFiles = [
        config.age.secrets.gluetunEnvironment.path
      ];
      environment = {
        DEV_MODE = "false";
      };
    };
  };
}
