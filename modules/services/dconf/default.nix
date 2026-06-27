{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.services.dconf;
in {
  options.cnix.services.dconf.enable = mkEnableOption "Enables dconf";

  config = mkIf cfg.enable {
    programs.dconf.enable = true;
  };
}
