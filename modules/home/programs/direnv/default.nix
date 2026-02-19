{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs;
in
{
  options = {
    home.programs.direnv.enable = mkEnableOption "Enables direnv";
  };
  config = mkIf cfg.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableNushellIntegration = mkIf cfg.nushell.enable true;
      enableBashIntegration = mkIf cfg.bash.enable true;
      enableZshIntegration = mkIf cfg.zsh.enable true;
      enableFishIntegration = mkIf cfg.fish.enable true;
    };
  };
}
