{
  inputs,
  config,
  lib,
  pkgs,
  umodPath,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.home.wm.hyprland.toothpick;
in {
  imports = [
    "${umodPath}/wm/hyprland/toothpick/appearance.nix"
    "${umodPath}/wm/hyprland/toothpick/inputs.nix"
    "${umodPath}/wm/hyprland/toothpick/keybinds.nix"
    "${umodPath}/wm/hyprland/toothpick/rules.nix"
    "${umodPath}/wm/hyprland/toothpick/startup.nix"
  ];

  options = {
    home.wm.hyprland.toothpick.enable = mkEnableOption "Enable Hyprland";
  };

  config = mkIf cfg.enable {
    home.wm.hyprland.toothpick = {
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
