{
  config,
  lib,
  pkgs,
  umodPath,
  osConfig,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types mkDefault;
  cfg = config.home.programs.hyprland;
  hyprlandPkg = pkgs.hyprland;
  isCnst = osConfig.networking.hostName == "cnix";
in {
  imports = ++ lib.optionals isCnst [
    "${umodPath}/programs/hyprland/cnst/appearance.nix"
    "${umodPath}/programs/hyprland/cnst/inputs.nix"
    "${umodPath}/programs/hyprland/cnst/keybinds.nix"
    "${umodPath}/programs/hyprland/cnst/rules.nix"
    "${umodPath}/programs/hyprland/cnst/startup.nix"
  ];

  options = {
    home.programs.hyprland = {
      enable = mkEnableOption "Enable Hyprland";
      user = mkOption {
        type = types.str;
        description = "The user-specific configuration directory for Hyprland.";
        example = "cnst";
      };
    };
  };

  config = mkIf cfg.enable {
    home.programs.hyprland.user = {
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
