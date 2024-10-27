{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.zsh;
in {
  options = {
    nixos.programs.zsh.enable = mkEnableOption "Enables zsh shell";
  };
  config = mkIf cfg.enable {
    programs.zsh.enable = cfg.enable;
  };
}
