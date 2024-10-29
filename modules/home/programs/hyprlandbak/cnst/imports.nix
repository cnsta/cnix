{
  config,
  lib,
  pkgs,
  umodPath,
  user,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types mkDefault;
  cfg = config.home.programs.hyprland.user;
in {
  imports = [
    "${umodPath}/programs/hyprland/cnst/appearance.nix"
    "${umodPath}/programs/hyprland/cnst/inputs.nix"
    "${umodPath}/programs/hyprland/cnst/keybinds.nix"
    "${umodPath}/programs/hyprland/cnst/rules.nix"
    "${umodPath}/programs/hyprland/cnst/startup.nix"
  ];

  options.home.programs.hyprland.user = {
    enable = mkEnableOption "Enable Hyprland user-specific configuration";
    appearance.enable = mkDefault true;
    inputs.enable = mkDefault true;
    keybinds.enable = mkDefault true;
    rules.enable = mkDefault true;
    startup.enable = mkDefault true;
  };

  config = mkIf cfg.enable {
    home.programs.hyprland.${user} = {
      appearance.enable = cfg.appearance.enable;
      inputs.enable = cfg.inputs.enable;
      keybinds.enable = cfg.keybinds.enable;
      rules.enable = cfg.rules.enable;
      startup.enable = cfg.startup.enable;
    };
  };
}
