{
  config,
  lib,
  pkgs,
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

    systemd = {
      services.podman-auto-update = {
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.podman}/bin/podman auto-update";
          ExecStartPost = "${pkgs.podman}/bin/podman image prune -f";
        };
      };
      timers.podman-auto-update = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "03:30";
          Persistent = true;
        };
      };
    };
  };
}
