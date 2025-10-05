{
  config,
  lib,
  self,
  ...
}:
with lib; let
  cfg = config.server.tailscale;
in {
  options.server.tailscale = {
    enable = mkEnableOption "Enable tailscale server configuration";
  };

  config = mkIf cfg.enable {
    age.secrets.sobotkaTsAuth.file = "${self}/secrets/sobotkaTsAuth.age";

    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "server";
      authKeyFile = config.age.secrets.sobotkaTsAuth.path;
      extraSetFlags = [
        "--advertise-exit-node"
        "--advertise-routes=192.168.88.0/24"
      ];
    };
  };
}
