{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.ghostty;
in {
  options = {
    nixos.programs.ghostty.enable = mkEnableOption "Enables ghostty";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [inputs.ghostty.packages.x86_64-linux.default];
  };
}
