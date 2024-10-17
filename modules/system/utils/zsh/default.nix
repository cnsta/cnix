{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.system.utils.zsh;
in {
  options = {
    system.utils.zsh.enable = mkEnableOption "Enables android tools";
  };
  config = mkIf cfg.enable {
    programs.zsh.enable = cfg.enable;
  };
}
