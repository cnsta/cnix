{
  inputs,
  config,
  lib,
  pkgs,
  userModules,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.modules.wm.hyprland.adam;
in {
  imports = [
    "${userModules}/wm/hyprland/adam/appearance.nix"
    "${userModules}/wm/hyprland/adam/inputs.nix"
    "${userModules}/wm/hyprland/adam/keybinds.nix"
    "${userModules}/wm/hyprland/adam/rules.nix"
    "${userModules}/wm/hyprland/adam/startup.nix"
  ];

  options = {
    modules.wm.hyprland.adam.enable = mkEnableOption "Enable Hyprland";
  };

  config = mkIf cfg.enable {
    modules.wm.hyprland.adam = {
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
