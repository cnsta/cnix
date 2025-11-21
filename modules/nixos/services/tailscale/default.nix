{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixos.services.tailscale;
in
{
  options.nixos.services.tailscale = {
    enable = mkEnableOption "Enable tailscale";
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;
  };
}
