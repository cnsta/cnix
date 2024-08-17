{
  inputs,
  config,
  lib,
  pkgs,
  userModules,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.modules.wm.hyprland.cnst;
in {
  imports = [
    "${userModules}/wm/hyprland/cnst/appearance.nix"
    "${userModules}/wm/hyprland/cnst/inputs.nix"
    "${userModules}/wm/hyprland/cnst/keybinds.nix"
    "${userModules}/wm/hyprland/cnst/rules.nix"
    "${userModules}/wm/hyprland/cnst/startup.nix"
  ];

  options = {
    modules.wm.hyprland.cnst.enable = mkEnableOption "Enable Hyprland";
  };

  config = mkIf cfg.enable {
    modules.wm.hyprland.cnst = {
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
