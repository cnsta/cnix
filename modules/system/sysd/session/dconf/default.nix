{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.sysd.session.dconf;
in {
  options = {
    system.sysd.session.dconf.enable = mkEnableOption "Enables dconf";
  };
  config = mkIf cfg.enable {
    programs.dconf.enable = true;
  };
}
