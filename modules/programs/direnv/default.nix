{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cnix.programs;
in {
  options.cnix.programs.direnv.enable = mkEnableOption "Enables direnv";

  config = mkIf cfg.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableFishIntegration = mkIf cfg.fish.enable true;
    };
  };
}
