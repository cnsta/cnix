{inputs, ...}: {
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./appearance.nix
    ./inputs.nix
    ./keybinds.nix
    ./rules.nix
    ./startup.nix
  ];
  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd = {
        variables = ["--all"];
        extraCommands = [
          "systemctl --user stop graphical-session.target"
          "systemctl --user start hyprland-session.target"
        ];
      };
    };
  };
}
