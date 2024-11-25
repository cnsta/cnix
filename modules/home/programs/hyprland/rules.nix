{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.hyprland.rules;
in {
  options = {
    home.programs.hyprland.rules.enable = mkEnableOption "Enables window rule settings in Hyprland";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        # === CALCURSE SETTINGS ===
        "size 843 650, initialTitle:^(floatcal)$"
        "move 100%-w-20 40, initialTitle:^(floatcal)$"
        "float, initialTitle:^(floatcal)$"

        # === TUIRUN SETTINGS ===
        "size 600 300, initialTitle:^(tuirun)$"
        "center, initialTitle:^(tuirun)$"
        # "workspace special:tuirun, initialTitle:^(tuirun)$"
        "noborder, initialTitle:^(tuirun)$"
        "float, initialTitle:^(tuirun)$"

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
        "float, class:^(Lxappearance)$"
        "float, class:^(com.github.hluk.copyq)$"
        "float, class:^(blueman-manager)$"
        "float, class:^(floatranger)$"
        "float, class:^(floatnnn)$"
      ];

      windowrule = [];
    };
  };
}
