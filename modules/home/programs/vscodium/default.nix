{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.vscodium;
in {
  options = {
    home.programs.vscodium.enable = mkEnableOption "Enables vscodium";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vscodium-fhs
    ];
  };
}
