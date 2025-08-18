{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption mkDefault;
  cfg = config.nixos.programs.hyprland;
in {
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
        package = pkgs.hyprland;
        withUWSM = cfg.withUWSM;
      };
      uwsm = mkIf cfg.withUWSM {
        enable = true;
        waylandCompositors = {
          hyprland = {
            prettyName = "Hyprland";
            comment = "Hyprland compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/Hyprland";
          };
        };
      };
    };

    environment.variables.NIXOS_OZONE_WL = "1";
  };
}
