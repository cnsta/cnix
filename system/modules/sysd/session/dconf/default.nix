{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sysd.session.dconf;
in {
  options = {
    modules.sysd.session.dconf.enable = mkEnableOption "Enables dconf";
  };
  config = mkIf cfg.enable {
    programs.dconf.enable = true;
  };
}
