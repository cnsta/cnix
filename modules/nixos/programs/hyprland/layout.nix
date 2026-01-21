{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkMerge;
  host = config.networking.hostName;
  cfg = config.nixos.programs.hyprland.rules;
  preferred = [ ",preferred,auto,1" ];
  # unknown = if config.[ "Unknown-1, disable" ];
in
{
  options = {
    nixos.programs.hyprland.rules.enable = mkEnableOption "Enables window rule settings in Hyprland";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.hyprland.settings = {
        monitor =
          map (
            m:
            let
              resolution =
                if m.width != null && m.height != null then
                  "${toString m.width}x${toString m.height}@${m.refreshRate}"
                else
                  "preferred";

              position = m.position or "auto";
              scale = m.scale;

              transformStr = if m.transform != 0 then ",transform,${toString m.transform}" else "";

              bitdepthStr = if m.bitDepth != null then ",bitdepth,${toString m.bitDepth}" else "";
            in
            "${m.name},${
              if m.enable then "${resolution},${position},${scale}${transformStr}${bitdepthStr}" else ""
            }"
          ) config.settings.monitors
          ++ preferred;

        workspace = map (m: "${m.workspace},monitor:${m.name}") (
          lib.filter (m: m.enable && m.workspace != null) config.settings.monitors
        );

        windowrule = [
          "match:title ^(VPN Switcher)$, float on, center on, size 0.18*monitor_w 0.2*monitor_h"

          "match:class ^(net.nokyan.Resources)$, float on, center on, size 0.5*monitor_w 0.7*monitor_h"

          "match:class ^(nwg-look)$, center on, float on"

          "match:class ^(oculante)$, float on, center on"

          "match:class ^(com.saivert.pwvucontrol)$, center on, float on, size 0.3*monitor_w 0.4*monitor_h"

          "match:class ^(org.gnome.FileRoller)$, float on"
          "match:class ^(org.freedesktop.impl.portal.desktop.kde)$, float on"
          "match:class ^(org.corectrl.CoreCtrl)$, float on"
          "match:class ^(feh)$, float on"
          "match:class ^(polkit-gnome-authentication-agent-1)$, float on"
          "match:class ^(org.gnome.Calculator)$, float on"
          "match:class ^(blueman-manager)$, float on"

          "match:class ^(discord)$, workspace 5 silent"
          "match:class ^(vesktop)$, workspace 5 silent"
          "match:class ^(steam_app_0)$, workspace 4 silent"
          "match:title ^(World of Warcraft)$, workspace 4 silent"

          "match:xwayland true, rounding 0"
        ];
        layerrule = [
          "match:namespace ^(waybar), blur true"
          "match:namespace ^(waybar), blur_popups true"
          "match:namespace ^(waybar), ignore_alpha 0.2"
          "match:namespace ^(waybar), no_anim true"

          "match:namespace ^(quickshell), blur true"
          "match:namespace ^(quickshell), blur_popups true"
          "match:namespace ^(quickshell), ignore_alpha 0.2"
          "match:namespace ^(quickshell), no_anim true"

          "match:namespace ^(fuzzel), blur true"
          "match:namespace ^(fuzzel), ignore_alpha 0.8"
          "match:namespace ^(fuzzel), no_anim true"
        ];
      };
    }
    (mkIf (host == "kima") {
      programs.hyprland.settings.workspace = [
        "name:1,monitor:DP-3"
        "name:2,monitor:DP-3"
        "name:3,monitor:DP-3"
        "name:4,monitor:DP-3"
        "name:5,monitor:HDMI-A-1"
        "name:6,monitor:DP-3"
        "name:7,monitor:DP-3"
        "name:8,monitor:DP-3"
        "name:9,monitor:DP-3"
        "name:10,monitor:DP-3"
      ];
    })
  ]);
}
