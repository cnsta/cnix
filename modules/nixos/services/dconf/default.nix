{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.dconf;
in
{
  options = {
    nixos.services.dconf.enable = mkEnableOption "Enables dconf";
  };
  config = mkIf cfg.enable {
    programs.dconf.enable = true;
  };
}
