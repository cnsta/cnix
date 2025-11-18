# yanked from https://github.com/NotAShelf/nyx/
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) getExe;
  inherit (builtins) readFile;
in
{
  home = {
    sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];
    file = {
      ".local/bin/spawn.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "spawn";
            runtimeInputs = with pkgs; [ niri ];
            text = readFile ./bin/spawn.sh;
          }
        );
      };

      ".local/bin/spawn-or-focus.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "spawn-or-focus";
            runtimeInputs = with pkgs; [ niri ];
            text = readFile ./bin/spawn-or-focus.sh;
          }
        );
      };

      ".local/bin/choosepaper.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "spawn";
            runtimeInputs = with pkgs; [
              fzf
              swaybg
              pistol
            ];
            text = readFile ./bin/choosepaper.sh;
          }
        );
      };

      ".local/bin/pwvucontrol-toggle.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "pwvucontrol-toggle";
            runtimeInputs = with pkgs; [ pwvucontrol ];
            text = readFile ./bin/pwvucontrol-toggle.sh;
          }
        );
      };

      ".local/bin/calcurse-toggle.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "calcurse-toggle";
            runtimeInputs = with pkgs; [ calcurse ];
            text = readFile ./bin/calcurse-toggle.sh;
          }
        );
      };

      ".local/bin/volume-control.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "volume-control";
            runtimeInputs = with pkgs; [
              wireplumber
              libnotify
            ];
            text = readFile ./bin/volume-control.sh;
          }
        );
      };

      ".local/bin/extract.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "extract";
            runtimeInputs = with pkgs; [
              zip
              unzip
              gnutar
              p7zip
            ];
            text = readFile ./bin/extract.sh;
          }
        );
      };
      # WAYBAR
      ".local/bin/waybar-systemd.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "waybar-systemd";
            runtimeInputs = with pkgs; [ hyprland ];
            text = readFile ./bin/waybar-systemd.sh;
          }
        );
      };
      ".local/bin/waybar-progress.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "waybar-progress";
            runtimeInputs = with pkgs; [ hyprland ];
            text = readFile ./bin/waybar-progress.sh;
          }
        );
      };
      ".local/bin/dunst.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "dunst";
            runtimeInputs = with pkgs; [
              hyprland
              dbus
            ];
            text = readFile ./bin/dunst.sh;
          }
        );
      };

      ".local/bin/mako.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "mako";
            runtimeInputs = with pkgs; [ hyprland ];
            text = readFile ./bin/mako.sh;
          }
        );
      };
      ".local/bin/mako-toggle.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "mako-toggle";
            runtimeInputs = with pkgs; [ hyprland ];
            text = readFile ./bin/mako-toggle.sh;
          }
        );
      };
    };
  };
}
