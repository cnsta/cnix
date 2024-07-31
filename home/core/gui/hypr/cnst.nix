{inputs, ...}: {
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./land/cnst
  ];
  wayland.windowManager.hyprland = {
    enable = true;

    systemd = {
      variables = ["--all"];
      # extraCommands = [
      #   "systemctl --user stop graphical-session.target"
      #   "systemctl --user start hyprland-session.target"
      # ];
    };
  };
}
