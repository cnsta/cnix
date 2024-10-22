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
    sessionPath = ["${config.home.homeDirectory}/.local/bin"];

    file = {
      ".local/bin/pavucontrol-toggle.sh" = {
        source = getExe (pkgs.writeShellApplication {
          name = "pavucontrol-toggle";
          runtimeInputs = with pkgs; [hyprland];
          text = readFile ./bin/pavucontrol-toggle.sh;
        });
      };

      ".local/bin/tuirun-toggle.sh" = {
        source = getExe (pkgs.writeShellApplication {
          name = "tuirun-toggle";
          runtimeInputs = with pkgs; [hyprland];
          text = readFile ./bin/tuirun-toggle.sh;
        });
      };

      ".local/bin/tuirun-debug.sh" = {
        source = getExe (pkgs.writeShellApplication {
          name = "tuirun-debug";
          runtimeInputs = with pkgs; [hyprland];
          text = readFile ./bin/tuirun-debug.sh;
        });
      };

      ".local/bin/calcurse-toggle.sh" = {
        source = getExe (pkgs.writeShellApplication {
          name = "calcurse-toggle";
          runtimeInputs = with pkgs; [hyprland];
          text = readFile ./bin/calcurse-toggle.sh;
        });
      };

      ".local/bin/volume-control.sh" = {
        source = getExe (pkgs.writeShellApplication {
          name = "volume-control";
          runtimeInputs = with pkgs; [pamixer libnotify];
          text = readFile ./bin/volume-control.sh;
        });
      };

      ".local/bin/extract.sh" = {
        source = getExe (pkgs.writeShellApplication {
          name = "extract";
          runtimeInputs = with pkgs; [zip unzip gnutar p7zip];
          text = readFile ./bin/extract.sh;
        });
      };
    };
  };
}
