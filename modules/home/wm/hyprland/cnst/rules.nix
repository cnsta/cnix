{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.wm.hyprland.cnst.rules;
in {
  options = {
    home.wm.hyprland.cnst.rules.enable = mkEnableOption "Enables window rule settings in Hyprland";
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      # CALCURSE SETTINGS
      windowrulev2 = [
        "float,initialTitle:(floatcal)"
        "size 843 650,initialTitle:(floatcal)"
        "move 100%-w-20 40,initialTitle:(floatcal)"
        "float,initialTitle:(tuirun)"
        "size 600 300,initialTitle:(tuirun)"
        "center,initialTitle:(tuirun)"
        "workspace special:tuirun,initialTitle:(tuirun)"
        "noborder,initialTitle:(tuirun)"
        #windowrulev2 = move 1708 32,class:(floatcal)
        "float,class:(org.keepassxc.KeePassXC)"
        "size 843 530,class:(org.keepassxc.KeePassXC)"
        "move 100%-w-20 40,class:(org.keepassxc.KeePassXC)"

        # RANGER/NNN SETTINGS
        "float,class:(floatranger)"
        "float,class:(floatnnn)"
        #windowrulev2 = size 843 650,class:(floatranger)
        #windowrulev2 = move 1708 32,class:(floatranger)
        #windowrulev2 = move 1708 32;size 843 650;dimaround;float,class:^(kitty)$,title:^(kitty)$
        # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
        "suppressevent maximize, class:.* # You'll probably like this."
        #windowrulev2 = noshadow, floating:0
        "float,class:^(imv)$"
        "float,class:^(com.github.hluk.copyq)$"
        "float,class:^(blueman-manager)$"
        "center,class:^(nwg-look)$"
        "float,class:^(nwg-look)$"
        "float,class:^(Lxappearance)$"
        "float,class:(pavucontrol)$"
        "move 100%-w-20 40,class:(pavucontrol)$"
        "float,class:^(polkit-gnome-authentication-agent-1)$"
        "float,class:^(org.gnome.Calculator)$"
        "size 741 585,class:(pavucontrol)$"
        "float,class:^(cnst.test)$"
        "float,class:^(org.corectrl.CoreCtrl)$"
        "float,class:^(feh)$"
        "float,class:^(com.example.gtk-adieux)$"
      ];
      windowrule = [
        "center, ^(xarchiver)$"
        "float, ^(xarchiver)$"
        "float, ^(org.gnome.FileRoller)$"
        "float, ^(org.freedesktop.impl.portal.desktop.kde)$"
      ];
    };
  };
}
