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

  config = mkIf cfg.enable (mkMerge [
    {
      programs.hyprland.settings = {
        windowrule = [
          # === CALCURSE SETTINGS ===
          "size 843 650, initialTitle:^(floatcal)$"
          "move 100%-w-20 40, initialTitle:^(floatcal)$"
          "float, initialTitle:^(floatcal)$"

          # === TUIRUN SETTINGS ===
          "size 600 300, title:^(tuirun)$"
          "center, title:^(tuirun)$"
          # "workspace special:tuirun, initialTitle:^(tuirun)$"
          "noborder, title:^(tuirun)$"
          "float, title:^(tuirun)$"

          # === KEEPASSXC SETTINGS ===
          "size 843 530, class:^(org.keepassxc.KeePassXC)$"
          "move 100%-w-20 40, class:^(org.keepassxc.KeePassXC)$"
          "float, class:^(org.keepassxc.KeePassXC)$"

          # === SUPPRESS MAXIMIZE EVENT ===
          "suppressevent maximize, class:.*" # Suppress maximize events for all windows

          # === NWG-LOOK SETTINGS ===
          "center, class:^(nwg-look)$"
          "float, class:^(nwg-look)$"

          # === OCULANTE SETTINGS ===
          "center, class:^(oculante)$"
          "float, class:^(oculante)$"

          # === PAVUCONTROL SETTINGS ===
          "move 100%-w-20 40, class:^(pavucontrol)$"
          "size 741 585, class:^(pavucontrol)$"
          "float, class:^(pavucontrol)$"

          # === XARCHIVER SETTINGS ===
          "center, class:^(xarchiver)$"
          "float, class:^(xarchiver)$"

          # === FLOATING APPLICATIONS ===
          "float, class:^(org.gnome.FileRoller)$"
          "float, class:^(org.freedesktop.impl.portal.desktop.kde)$"
          "float, class:^(org.corectrl.CoreCtrl)$"
          "float, class:^(feh)$"
          "float, class:^(polkit-gnome-authentication-agent-1)$"
          "float, class:^(org.gnome.Calculator)$"
          "float, class:^(com.github.hluk.copyq)$"
          "float, class:^(blueman-manager)$"

          # === WORKSPACE RULES ===
          "workspace 5 silent, class:^(discord)$"
          "workspace 5 silent, class:^(vesktop)$"
          "workspace 4 silent, class:^(steam_app_0)$"
          "workspace 4 silent, title:^(World of Warcraft)$"
        ];
        layerrule = [
          "animation fade,hyprpicker"
          "animation fade,selection"

          "noanim,waybar"
          "ignorezero,waybar"
          "ignorealpha 0.0,waybar"

          "blur,notifications"
          "ignorezero,notifications"

          "noanim,wallpaper"
        ];
      };
    }
    (mkIf (host == "cnixtop") {
      programs.hyprland.settings.workspace = [
        "name:1,monitor:DP-3"
        "name:2,monitor:DP-3"
        "name:3,monitor:DP-3"
        "name:4,monitor:DP-3"
        "name:5,monitor:DP-4"
        "name:6,monitor:DP-3"
        "name:7,monitor:DP-3"
        "name:8,monitor:DP-3"
        "name:9,monitor:DP-3"
        "name:10,monitor:DP-3"
      ];
    })
    (mkIf (host == "cnixpad") {
      programs.hyprland.settings.workspace = [];
    })
    (mkIf (host == "toothpc") {
      programs.hyprland.settings.workspace = [];
    })
  ]);
}
