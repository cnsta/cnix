{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkDefault
    ;

  system = pkgs.stdenv.hostPlatform.system;
  hyprFlake = inputs.hyprland.packages.${system}.hyprland;
  portalFlake = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  cfg = config.nixos.programs.hyprland;
in
{
  imports = [
    inputs.hyprland.nixosModules.default
    ./appearance.nix
    ./inputs.nix
    ./keybinds.nix
    ./layout.nix
    ./startup.nix
  ];

  options = {
    nixos.programs.hyprland = {
      enable = mkEnableOption "Enable Hyprland";
      withUWSM = mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use UWSM to handle hyprland session";
      };
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

    programs = {
      hyprland = {
        enable = true;
        withUWSM = true;
        # package = pkgs.hyprland;
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
      };
    };

    environment.variables.NIXOS_OZONE_WL = "1";
  };
}
