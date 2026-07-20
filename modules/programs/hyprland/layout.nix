{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkEnableOption
    mkMerge
    optionalAttrs
    ;
  host = config.networking.hostName;
  cfg = config.cnix.programs.hyprland.rules;
in {
  options.cnix.programs.hyprland.rules.enable =
    mkEnableOption "Enables window rule settings in Hyprland";
  config = mkIf cfg.enable (mkMerge [
    {
      cnix.programs.hyprland.lua = {
        monitors =
          (map (
              m:
                if m.enable
                then
                  {
                    output = m.name;
                    mode =
                      if m.width != null && m.height != null
                      then "${toString m.width}x${toString m.height}@${m.refreshRate}"
                      else "preferred";
                    position = m.position or "auto";
                    scale = m.scale;
                  }
                  // optionalAttrs (m.transform != 0) {transform = m.transform;}
                  // optionalAttrs (m.bitDepth != null) {bitdepth = m.bitDepth;}
                else {
                  output = m.name;
                  disabled = true;
                }
            )
            config.cnix.settings.monitors)
          ++ [
            {
              output = "";
              mode = "preferred";
              position = "auto";
              scale = "auto";
            }
          ];

        workspaceRules = map (m: {
          workspace = toString m.workspace;
          monitor = m.name;
        }) (lib.filter (m: m.enable && m.workspace != null) config.cnix.settings.monitors);

        windowRules = [
          {
            match = {
              title = "^(VPN Switcher)$";
            };
            float = true;
            center = true;
            size = "0.18*monitor_w 0.2*monitor_h";
          }
          {
            match = {
              title = "^(Import VPN configurations)$";
            };
            float = true;
            center = true;
            size = "0.26*monitor_w 0.32*monitor_h";
          }
          {
            match = {
              title = "^(byt)$";
            };
            float = true;
            center = true;
            size = "0.22*monitor_w 0.3*monitor_h";
          }
          {
            match = {
              class = "^(net.nokyan.Resources)$";
            };
            float = true;
            center = true;
            size = "0.5*monitor_w 0.7*monitor_h";
          }
          {
            match = {
              class = "^(nwg-look)$";
            };
            float = true;
            center = true;
          }
          {
            match = {
              class = "^(swayimg)$";
            };
            float = true;
            center = true;
          }
          {
            match = {
              class = "^(com.saivert.pwvucontrol)$";
            };
            float = true;
            center = true;
            size = "0.3*monitor_w 0.4*monitor_h";
          }
          {
            match = {
              class = "^(org.gnome.FileRoller)$";
            };
            float = true;
          }
          {
            match = {
              class = "^(org.freedesktop.impl.portal.desktop.kde)$";
            };
            float = true;
          }
          {
            match = {
              class = "^(org.corectrl.CoreCtrl)$";
            };
            float = true;
          }
          {
            match = {
              class = "^(polkit-gnome-authentication-agent-1)$";
            };
            float = true;
          }
          {
            match = {
              class = "^(org.gnome.Calculator)$";
            };
            float = true;
          }
          {
            match = {
              class = "^(blueman-manager)$";
            };
            float = true;
          }
          {
            match = {
              class = "^(discord)$";
            };
            workspace = "5 silent";
          }
          {
            match = {
              class = "^(vesktop)$";
            };
            workspace = "5 silent";
          }
          {
            match = {
              class = "^(steam_app_.*)$";
            };
            workspace = "4 silent";
          }
          {
            match = {
              title = "^(World of Warcraft)$";
            };
            workspace = "4 silent";
          }
          {
            match = {
              xwayland = true;
            };
            rounding = 0;
          }
        ];

        layerRules = [
          {
            match = {
              namespace = "^(waybar)";
            };
            blur = true;
            blur_popups = true;
            ignore_alpha = 0.2;
            no_anim = true;
          }
          {
            match = {
              namespace = "^(quickshell)";
            };
            blur = true;
            blur_popups = true;
            ignore_alpha = 0.2;
            no_anim = true;
          }
          {
            match = {
              namespace = "^(cnixshell)";
            };
            blur = true;
            blur_popups = true;
            ignore_alpha = 0.2;
            no_anim = true;
          }
          {
            match = {
              namespace = "^(fuzzel)";
            };
            blur = true;
            ignore_alpha = 0.8;
            no_anim = true;
          }
        ];
      };
    }

    (mkIf (host == "kima") {
      cnix.programs.hyprland.lua.workspaceRules = [
        {
          workspace = "1";
          monitor = "DP-3";
        }
        {
          workspace = "2";
          monitor = "DP-3";
        }
        {
          workspace = "3";
          monitor = "DP-3";
        }
        {
          workspace = "4";
          monitor = "DP-3";
        }
        {
          workspace = "5";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "6";
          monitor = "DP-3";
        }
        {
          workspace = "7";
          monitor = "DP-3";
        }
        {
          workspace = "8";
          monitor = "DP-3";
        }
        {
          workspace = "9";
          monitor = "DP-3";
        }
        {
          workspace = "10";
          monitor = "DP-3";
        }
      ];
    })
  ]);
}
