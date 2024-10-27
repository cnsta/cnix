{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.anyrun;
in {
  options = {
    nixos.programs.anyrun.enable = mkEnableOption "Enables anyrun";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.anyrun
    ];
  };
}
