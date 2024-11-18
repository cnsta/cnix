{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.home.programs.hyprland;
  hyprlandPkg = inputs.hyprland.packages.${pkgs.system}.default;
in {
  imports = [
    ./appearance.nix
    ./inputs.nix
    ./keybinds.nix
    ./rules.nix
    ./startup.nix
  ];

  options = {
    home.programs.hyprland = {
      enable = mkEnableOption "Enable Hyprland";
    };
  };

  config = mkIf cfg.enable {
    home.programs.hyprland = {
      appearance.enable = mkDefault true;
      inputs.enable = mkDefault true;
      keybinds.enable = mkDefault true;
      rules.enable = mkDefault true;
      startup.enable = mkDefault true;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = hyprlandPkg;
      systemd = {
        enable = false;
        variables = ["--all"];
        extraCommands = [
          "systemctl --user stop graphical-session.target"
          "systemctl --user start hyprland-session.target"
        ];
      };
    };

    systemd.user.targets.tray.Unit.Requires = lib.mkForce ["graphical-session.target"];
  };
}
