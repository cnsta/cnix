{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.fish;
in {
  options = {
    nixos.programs.fish.enable = mkEnableOption "Enables fish shell";
  };
  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      vendor = {
        completions.enable = true;
        config.enable = true;
        functions.enable = true;
      };
    };
  };
}
