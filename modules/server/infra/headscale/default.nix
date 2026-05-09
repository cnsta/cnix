{
  config,
  lib,
  self,
  ...
}:
with lib;
let
  cfg = config.cnix.server.infra.headscale;
in
{
  options.cnix.server.infra.headscale = {
    enable = mkEnableOption "Enable headscale server configuration";
  };
  config = mkIf cfg.enable {
    age.secrets.sobotkaTsAuth.file = "${self}/secrets/sobotkaTsAuth.age";

    services.headscale = {
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
