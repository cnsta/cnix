{
  imports = [
    ./land/appearance.nix
    ./land/inputs.nix
    ./land/keybinds.nix
    ./land/rules.nix
    ./land/startup.nix
  ];
  wayland.windowManager.hyprland = {
    enable = true;

    systemd = {
      variables = ["--all"];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
  };
}
