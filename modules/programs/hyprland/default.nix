{
  config,
  lib,
  inputs,
  pkgs,
  clib,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkEnableOption
    mkOption
    mkDefault
    types
    ;
  cfg = config.cnix.programs.hyprland;
  acct = config.cnix.settings.accounts;
in {
  imports = [
    inputs.hyprland.nixosModules.default
    ./appearance.nix
    ./inputs.nix
    ./keybinds.nix
    ./layout.nix
    ./startup.nix
  ];

  options.cnix.programs.hyprland = {
    enable = mkEnableOption "Enable Hyprland";
    withUWSM = mkOption {
      type = types.bool;
      default = false;
      description = "Use UWSM to handle hyprland session";
    };

    lua = {
      configParts = mkOption {
        type = types.listOf types.anything;
        default = [];
      };
      env = mkOption {
        type = types.attrsOf types.str;
        default = {};
      };
      monitors = mkOption {
        type = types.listOf types.anything;
        default = [];
      };
      workspaceRules = mkOption {
        type = types.listOf types.anything;
        default = [];
      };
      windowRules = mkOption {
        type = types.listOf types.anything;
        default = [];
      };
      layerRules = mkOption {
        type = types.listOf types.anything;
        default = [];
      };
      curves = mkOption {
        type = types.listOf types.anything;
        default = [];
      };
      animations = mkOption {
        type = types.listOf types.anything;
        default = [];
      };
      gestures = mkOption {
        type = types.listOf types.anything;
        default = [];
      };
      binds = mkOption {
        type = types.listOf types.anything;
        default = [];
      };
      startup = mkOption {
        type = types.listOf types.str;
        default = [];
      };
    };
  };

  config = mkIf cfg.enable {
    cnix.programs.hyprland = {
      appearance.enable = mkDefault true;
      inputs.enable = mkDefault true;
      keybinds.enable = mkDefault true;
      rules.enable = mkDefault true;
      startup.enable = mkDefault true;
    };

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        preferred.default = ["hyprland"];
        hyprland.default = [
          "hyprland"
          "gtk"
        ];
      };
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    environment.variables.NIXOS_OZONE_WL = "1";

    hjem.users = lib.genAttrs acct.defaultUsers (_: {
      files.".config/hypr/hyprland.lua" = {
        text = clib.toHyprlua {
          config = lib.foldl' lib.recursiveUpdate {} cfg.lua.configParts;
          inherit
            (cfg.lua)
            env
            monitors
            workspaceRules
            windowRules
            layerRules
            curves
            animations
            gestures
            binds
            startup
            ;
        };
        clobber = true;
      };
    });
  };
}
