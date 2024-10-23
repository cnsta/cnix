{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.utils.zsh;
in {
  options = {
    nixos.utils.zsh.enable = mkEnableOption "Enables zsh shell";
  };
  config = mkIf cfg.enable {
    programs.zsh.enable = cfg.enable;
  };
}
