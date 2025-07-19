{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkMerge;
  host = config.networking.hostName;
  cfg = config.nixos.programs.hyprland.rules;
in {
  options = {
    nixos.programs.hyprland.rules.enable = mkEnableOption "Enables window rule settings in Hyprland";
  };

  config = mkIf cfg.enable {
    programs.hyprland.settings = {
      monitor =
        map (
          m: let
            resolution =
              if m.width != null && m.height != null
              then "${toString m.width}x${toString m.height}@${toString m.refreshRate}"
              else "preferred";

            position = m.position or "auto";
            scale = m.scale;

            transformStr =
              if m.transform != 0
              then ",transform,${toString m.transform}"
              else "";

            bitdepthStr =
              if m.bitDepth != null
              then ",bitdepth,${toString m.bitDepth}"
              else "";
          in "${m.name},${
            if m.enabled
            then "${resolution},${position},${scale}${transformStr}${bitdepthStr}"
            else "disable"
          }"
        )
        config.settings.monitors;

      workspace = map (
        m: "${m.workspace},monitor:${m.name}"
      ) (lib.filter (m: m.enabled && m.workspace != null) config.settings.monitors);

      windowrule = [
        "size 843 650, initialTitle:^(floatcal)$"
        "move 100%-w-20 40, initialTitle:^(floatcal)$"
        "float, initialTitle:^(floatcal)$"

        "size 600 300, title:^(tuirun)$"
        "center, title:^(tuirun)$"
        "noborder, title:^(tuirun)$"
        "float, title:^(tuirun)$"

        "size 843 530, class:^(org.keepassxc.KeePassXC)$"
        "move 100%-w-20 40, class:^(org.keepassxc.KeePassXC)$"
        "float, class:^(org.keepassxc.KeePassXC)$"

        "size 50% 70%, class:^(net.nokyan.Resources)$"
        "center, class:^(net.nokyan.Resources)$"
        "float, class:^(net.nokyan.Resources)$"

        "suppressevent maximize, class:.*"

        "center, class:^(nwg-look)$"
        "float, class:^(nwg-look)$"

        "center, class:^(oculante)$"
        "float, class:^(oculante)$"

        "move 100%-w-20 40, class:^(pavucontrol)$"
        "size 741 585, class:^(pavucontrol)$"
        "float, class:^(pavucontrol)$"

        "center, class:^(xarchiver)$"
        "float, class:^(xarchiver)$"

        "float, class:^(org.gnome.FileRoller)$"
        "float, class:^(org.freedesktop.impl.portal.desktop.kde)$"
        "float, class:^(org.corectrl.CoreCtrl)$"
        "float, class:^(feh)$"
        "float, class:^(polkit-gnome-authentication-agent-1)$"
        "float, class:^(org.gnome.Calculator)$"
        "float, class:^(com.github.hluk.copyq)$"
        "float, class:^(blueman-manager)$"

        # "workspace 5 silent, class:^(discord)$"
        # "workspace 5 silent, class:^(vesktop)$"
        "workspace 4 silent, class:^(steam_app_0)$"
        "workspace 4 silent, title:^(World of Warcraft)$"
      ];
      layerrule = [
        "animation fade,hyprpicker"
        "animation fade,selection"

        "animation fade,waybar"
        "ignorezero,waybar"
        "ignorealpha 0.0,waybar"
        "blur,waybar"

        "blur,notifications"
        "ignorezero,notifications"

        "noanim,wallpaper"
        "noanim,launcher"
      ];
    };
  };
}
