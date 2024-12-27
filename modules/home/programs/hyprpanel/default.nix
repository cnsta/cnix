{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.hyprpanel;
in {
  options = {
    home.programs.hyprpanel.enable = mkEnableOption "Enables hyprpanel";
  };
  imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];

  config = mkIf cfg.enable {
    programs.hyprpanel = {
      # Enable the module.
      # Default: false
      enable = true;

      # Automatically restart HyprPanel with systemd.
      # Useful when updating your config so that you
      # don't need to manually restart it.
      # Default: false
      systemd.enable = true;

      # Add '/nix/store/.../hyprpanel' to the
      # 'exec-once' in your Hyprland config.
      # Default: false
      hyprland.enable = false;

      # Fix the overwrite issue with HyprPanel.
      # See below for more information.
      # Default: false
      overwrite.enable = false;

      # Import a specific theme from './themes/*.json'.
      # Default: ""
      theme = "gruvbox_split";

      # Configure bar layouts for monitors.
      # See 'https://hyprpanel.com/configuration/panel.html'.
      # Default: null
      layout = {
        "bar.layouts" = {
          "0" = {
            left = ["dashboard"];
            middle = ["workspaces"];
            right = ["volume" "systray" "notifications"];
          };
        };
      };

      # Configure and theme *most* of the options from the GUI.
      # See './nix/module.nix:103'.
      # Default: <same as gui>
      settings = {
        bar.launcher.autoDetectIcon = true;
        bar.workspaces.show_icons = true;

        menus.clock = {
          time = {
            military = true;
            hideSeconds = true;
          };
          weather.unit = "metric";
        };

        menus.dashboard.directories.enabled = false;
        menus.dashboard.stats.enable_gpu = true;

        theme.bar.transparent = true;

        theme.font = {
          name = "Input Mono Narrow Light";
          size = "16px";
        };
      };
    };
  };
}
