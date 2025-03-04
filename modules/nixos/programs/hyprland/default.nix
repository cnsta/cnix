{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.nixos.programs.hyprland;
in {
  imports = [
    inputs.hyprland.nixosModules.default
    ./appearance.nix
    ./inputs.nix
    ./keybinds.nix
    ./rules.nix
    ./startup.nix
  ];

  options = {
    nixos.programs.hyprland = {
      enable = mkEnableOption "Enable Hyprland";
    };
  };

  config = mkIf cfg.enable {
    nixos.programs.hyprland = {
      appearance.enable = mkDefault true;
      inputs.enable = mkDefault true;
      keybinds.enable = mkDefault true;
      rules.enable = mkDefault true;
      startup.enable = mkDefault true;
    };

    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    environment.variables.NIXOS_OZONE_WL = "1";
  };
}
