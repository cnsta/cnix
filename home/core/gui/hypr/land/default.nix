{
  wayland.windowManager.hyprland = {
    enable = true;

    systemd = {
      variables = ["--all"];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
      extraConfig = ''
        åsource=./land/appearance.conf
        source=./land/inputs.conf
        source=./land/keybinds.conf
        source=./land/rules.conf
        source=./land/startup.conf
      '';
    };
  };
}
