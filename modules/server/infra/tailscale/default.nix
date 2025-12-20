{
  config,
  lib,
  self,
  ...
}:
with lib;
let
  cfg = config.server.infra.tailscale;
in
{
  options.server.infra.tailscale = {
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
      ];
    };
  };
}
