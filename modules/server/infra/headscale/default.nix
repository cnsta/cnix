{
  config,
  lib,
  self,
  ...
}:
with lib;
let
  cfg = config.server.infra.headscale;
in
{
  options.server.infra.headscale = {
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
