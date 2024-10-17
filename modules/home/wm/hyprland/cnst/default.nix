{
  inputs,
  config,
  lib,
  pkgs,
  umodPath,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.home.wm.hyprland.cnst;
in {
  imports = [
    "${umodPath}/wm/hyprland/cnst/appearance.nix"
    "${umodPath}/wm/hyprland/cnst/inputs.nix"
    "${umodPath}/wm/hyprland/cnst/keybinds.nix"
    "${umodPath}/wm/hyprland/cnst/rules.nix"
    "${umodPath}/wm/hyprland/cnst/startup.nix"
  ];

  options = {
    home.wm.hyprland.cnst.enable = mkEnableOption "Enable Hyprland";
  };

  config = mkIf cfg.enable {
    home.wm.hyprland.cnst = {
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
