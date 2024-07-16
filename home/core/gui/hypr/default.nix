{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      source = [
        "./land/appearance.conf"
        "./land/inputs.conf"
        "./land/keybinds.conf"
        "./land/rules.conf"
        "./land/startup.conf"
      ];
    };

    systemd = {
      variables = ["--all"];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
