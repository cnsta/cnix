{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.services.session.dconf;
in {
  options = {
    nixos.services.session.dconf.enable = mkEnableOption "Enables dconf";
  };
  config = mkIf cfg.enable {
    programs.dconf.enable = true;
  };
}
