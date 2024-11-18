{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.nwg-bar;
in {
  options = {
    home.programs.nwg-bar.enable = mkEnableOption "Enables nwg-bar";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nwg-bar
    ];
    xdg.configFile."nwg-bar/bar.json".text = builtins.toJSON [
      {
        label = "Lock";
        exec = "hyprlock";
        icon = "${config.gtk.iconTheme.package}/share/icons/Adwaita/symbolic/status/system-lock-screen-symbolic.svg";
      }
      {
        label = "Logout";
        exec = "hyprctl dispatch exit";
        icon = "${config.gtk.iconTheme.package}/share/icons/Adwaita/symbolic/actions/system-log-out-symbolic.svg";
      }
      {
        label = "Reboot";
        exec = "systemctl reboot";
        icon = "${config.gtk.iconTheme.package}/share/icons/Adwaita/symbolic/actions/system-reboot-symbolic.svg";
      }
      {
        label = "Shutdown";
        exec = "systemctl -i poweroff";
        icon = "${config.gtk.iconTheme.package}/share/icons/Adwaita/symbolic/actions/system-shutdown-symbolic.svg";
      }
    ];
    xdg.configFile."nwg-bar/style.css".text = ''
      window {
              background-color: rgba (60, 56, 54, 0.6)
      }

      /* Outer bar container, takes all the window width/height */
      #outer-box {
      	margin: 0px
      }

      /* Inner bar container, surrounds buttons */
      #inner-box {
      	background-color: rgba (28, 28, 28, 0.85);
      	border-radius: 0px;
      	border-style: none;
      	border-width: 1px;
      	border-color: rgba (156, 142, 122, 0.7);
      	padding: 5px;
      	margin: 5px
      }

      button, image {
      	background: none;
      	border: none;
      	box-shadow: none
      }

      button {
      	padding-left: 10px;
      	padding-right: 10px;
      	margin: 5px
      }

      button:hover {
      	background-color: rgba (255, 255, 255, 0.35)
      }
    '';
  };
}
