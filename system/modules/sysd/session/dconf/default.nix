{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.sysd.session.dconf;
in {
  options = {
    systemModules.sysd.session.dconf.enable = mkEnableOption "Enables dconf";
  };
  config = mkIf cfg.enable {
    programs.dconf.enable = true;
  };
}
