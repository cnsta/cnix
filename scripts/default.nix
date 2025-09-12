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
      ".local/bin/spawn-or-focus.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "spawn-or-focus";
            runtimeInputs = with pkgs; [ niri ];
            text = readFile ./bin/spawn-or-focus.sh;
          }
        );
      };

      ".local/bin/pavucontrol-toggle.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "pavucontrol-toggle";
            runtimeInputs = with pkgs; [ hyprland ];
            text = readFile ./bin/pavucontrol-toggle.sh;
          }
        );
      };

      ".local/bin/tuirun-toggle.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "tuirun-toggle";
            runtimeInputs = with pkgs; [
              hyprland
              uwsm
            ];
            text = readFile ./bin/tuirun-toggle.sh;
          }
        );
      };

      ".local/bin/tuirun-debugger.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "tuirun-debugger";
            runtimeInputs = with pkgs; [ hyprland ];
            text = ''
              # Save environment to file
              env > /tmp/tuirun-env.txt
              # Run tuirun
              /etc/profiles/per-user/cnst/bin/tuirun
            '';
          }
        );
      };

      ".local/bin/calcurse-toggle.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "calcurse-toggle";
            runtimeInputs = with pkgs; [ hyprland ];
            text = readFile ./bin/calcurse-toggle.sh;
          }
        );
      };

      ".local/bin/volume-control.sh" = {
        source = getExe (
          pkgs.writeShellApplication {
            name = "volume-control";
            runtimeInputs = with pkgs; [
              pamixer
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
