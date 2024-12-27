{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption singleton;
  inherit (builtins) toJSON;
  cfg = config.home.programs.ironbar;
in {
  options = {
    home.programs.ironbar.enable = mkEnableOption "Enables ironbar";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ironbar];

    xdg.configFile = {
      "ironbar/config.json".text = toJSON {
        name = "main";
        icon_theme = "Fluent-dark";
        position = "bottom";
        anchor_to_edges = true;

        start = [
          {
            name = "startMenu";
            type = "label";
            label = "❄";
            on_mouse_enter = "tuirun-toggle.sh";
          }
        ];

        center = singleton {
          type = "launcher";
          icon_size = 39;

          favorites = [
            "zen"
            "alacritty"
            "thunar"
          ];
        };

        end = [
          {
            type = "tray";
          }
          {
            type = "upower";
            show_if = "upower -e | grep BAT";
          }
          {
            type = "clock";
            format = "%x（%a）%R";
          }
        ];
      };

      "ironbar/style.css".text =
        # css
        ''
          * {
            font-family: "Input Sans Narrow", "Font Awesome 6 Free Solid";
            font-size: 13px;
            text-shadow: 2px 2px #3c3836;
            border: none;
            border-radius: 0;
            outline: none;
            font-weight: 500;
            background: none;
            color: #fbf1c7;
          }

          .background {
            background: alpha(#3c3836, 0.925);
          }

          button:hover {
            background: alpha(#504945, 0.8);
          }

          #bar {
            border-top: 1px solid alpha(#504945, 0.925);
          }

          .label, .script, .tray {
            padding-left: 0.5em;
            padding-right: 0.5em;
          }

          .tray .item {
            padding-left: 0.5em;
          }

          .upower {
            padding-left: 0.2em;
            padding-right: 0.2em;
          }

          .upower .label {
            padding-left: 0;
            padding-right: 0;
          }

          .popup {
            border: 1px solid #504945;
            padding: 1em;
          }

          .popup-clock .calendar-clock {
            font-family: "Input Mono Narrow";
            font-size: 2.5em;
            padding-bottom: 0.1em;
          }

          .popup-clock .calendar .header {
            padding-top: 1em;
            border-top: 1px solid #504945;
            font-size: 1.5em;
          }

          .popup-clock .calendar {
            padding: 0.2em 0.4em;
          }

          .popup-clock .calendar:selected {
            color: #32302f;
          }

          .launcher .item {
            padding-left: 1em;
            padding-right: 1em;
            margin-right: 4px;
          }

          button:active {
            background: alpha(#7c6f64, 0.8);
          }

          .launcher .open {
            box-shadow: inset 0 -2px alpha(#7c6f64, 0.8);
          }

          .launcher .focused {
            box-shadow: inset 0 -2px alpha(#32302f, 0.8);
            background: alpha(#504945, 0.8);
          }

          .popup-launcher {
            padding: 0;
          }

          .popup-launcher .popup-item:not(:first-child) {
            border-top: 1px solid #504945;
          }

          #startMenu {
            padding-left: 1em;
            padding-right: 0.5em;
          }
        '';
    };
  };
}
