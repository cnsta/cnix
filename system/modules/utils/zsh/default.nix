{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.utils.zsh;
in {
  options = {
    modules.utils.zsh.enable = mkEnableOption "Enables android tools";
  };
  config = mkIf cfg.enable {
    programs.zsh.enable = cfg.enable;
  };
}
