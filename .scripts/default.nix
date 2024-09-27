# yanked from https://github.com/NotAShelf/nyx/
{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe;
  inherit (builtins) readFile;
in {
  home = {
    # Ensure the scripts are linked in the session PATH
    sessionPath = ["${config.home.homeDirectory}/.local/bin"];

    # Link the pavucontrol script to the local PATH
    file = {
      ".local/bin/pavucontrol-toggle.sh" = {
        source = getExe (pkgs.writeShellApplication {
          name = "pavucontrol-toggle";
          runtimeInputs = with pkgs; [hyprland]; # Add any required runtime dependencies here
          text = readFile ./bin/pavucontrol-toggle.sh; # Path to your pavucontrol.sh script
        });
      };

      ".local/bin/tuirun-toggle.sh" = {
        source = getExe (pkgs.writeShellApplication {
          name = "tuirun-toggle";
          runtimeInputs = with pkgs; [hyprland]; # Add any required runtime dependencies here
          text = readFile ./bin/tuirun-toggle.sh; # Path to your tuirun-toggle.sh script
        });
      };

      ".local/bin/tuirun-debug.sh" = {
        source = getExe (pkgs.writeShellApplication {
          name = "tuirun-debug";
          runtimeInputs = with pkgs; [hyprland]; # Add any required runtime dependencies here
          text = readFile ./bin/tuirun-debug.sh; # Path to your tuirun-toggle.sh script
        });
      };

      ".local/bin/calcurse-toggle.sh" = {
        source = getExe (pkgs.writeShellApplication {
          name = "calcurse-toggle";
          runtimeInputs = with pkgs; [hyprland]; # Add any required runtime dependencies here
          text = readFile ./bin/calcurse-toggle.sh; # Path to your calcurse-toggle.sh script
        });
      };

      ".local/bin/volume-control.sh" = {
        source = getExe (pkgs.writeShellApplication {
          name = "volume-control";
          runtimeInputs = with pkgs; [pamixer libnotify]; # Add any required runtime dependencies here
          text = readFile ./bin/volume-control.sh; # Path to your volume-control.sh script
        });
      };

      ".local/bin/extract.sh" = {
        # Stolen from NotAShelf
        source = getExe (pkgs.writeShellApplication {
          name = "extract";
          runtimeInputs = with pkgs; [zip unzip gnutar p7zip];
          text = readFile ./bin/extract.sh;
        });
      };
    };
  };
}
