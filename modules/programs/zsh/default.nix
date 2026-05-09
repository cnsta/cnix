{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.zsh;
in
{
  options.cnix.programs.zsh.enable = mkEnableOption "Enables zsh shell";

  config = mkIf cfg.enable {
    programs.zsh.enable = cfg.enable;
  };
}
