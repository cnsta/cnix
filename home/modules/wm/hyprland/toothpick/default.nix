{
  inputs,
  config,
  lib,
  pkgs,
  userModules,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.modules.wm.hyprland.toothpick;
in {
  imports = [
    "${userModules}/wm/hyprland/toothpick/appearance.nix"
    "${userModules}/wm/hyprland/toothpick/inputs.nix"
    "${userModules}/wm/hyprland/toothpick/keybinds.nix"
    "${userModules}/wm/hyprland/toothpick/rules.nix"
    "${userModules}/wm/hyprland/toothpick/startup.nix"
  ];

  options = {
    modules.wm.hyprland.toothpick.enable = mkEnableOption "Enable Hyprland";
  };

  config = mkIf cfg.enable {
    modules.wm.hyprland.toothpick = {
      appearance.enable = mkDefault cfg.enable;
      inputs.enable = mkDefault cfg.enable;
      keybinds.enable = mkDefault cfg.enable;
      rules.enable = mkDefault cfg.enable;
      startup.enable = mkDefault cfg.enable;
    };
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.default;
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
