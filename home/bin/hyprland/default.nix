{
  lib,
  inputs,
  config,
  ...
}: {
  options = {
    # Define an option to enable the `cnst` configuration
    cnst.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the cnst configuration";
    };

    # Define an option to enable the `adam` configuration
    adam.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the adam configuration";
    };

    # Define an option to enable the `toothpick` configuration
    toothpick.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the toothpick configuration";
    };
  };

  config = {
    # Hyprland configuration shared across all users
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

  # Conditionally include configurations based on the enable flags
  imports =
    lib.optional config.cnst.enable ./cnst
    ++ lib.optional config.adam.enable ./adam
    ++ lib.optional config.toothpick.enable ./toothpick;
}
