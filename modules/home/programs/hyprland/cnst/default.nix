{
  inputs,
  config,
  lib,
  pkgs,
  umodPath,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.home.programs.hyprland.cnst;
in {
  imports = [
    "${umodPath}/programs/hyprland/cnst/appearance.nix"
    "${umodPath}/programs/hyprland/cnst/inputs.nix"
    "${umodPath}/programs/hyprland/cnst/keybinds.nix"
    "${umodPath}/programs/hyprland/cnst/rules.nix"
    "${umodPath}/programs/hyprland/cnst/startup.nix"
  ];

  options = {
    home.programs.hyprland.cnst.enable = mkEnableOption "Enable Hyprland";
  };

  config = mkIf cfg.enable {
    home.programs.hyprland.cnst = {
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
