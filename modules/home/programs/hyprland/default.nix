{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types mkDefault;
  cfg = config.home.programs.hyprland;
  hyprlandPkg = pkgs.hyprland;
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
      user = mkOption {type = types.enum ["cnst" "toothpick"];};
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
        variables = ["--all"];
        extraCommands = [
          "systemctl --user stop graphical-session.target"
          "systemctl --user start hyprland-session.target"
        ];
      };
    };
  };
}
