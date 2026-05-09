{ pkgs, ... }:
with builtins;
let
  mkScript =
    {
      name,
      runtimeInputs,
      file,
    }:
    pkgs.writeShellApplication {
      name = "${name}.sh";
      inherit runtimeInputs;
      text = readFile file;
    };

  scripts = with pkgs; [
    (mkScript {
      name = "spawn";
      runtimeInputs = [ niri ];
      file = ./bin/spawn.sh;
    })
    (mkScript {
      name = "spawn-or-focus";
      runtimeInputs = [ niri ];
      file = ./bin/spawn-or-focus.sh;
    })
    (mkScript {
      name = "vpnswitcher";
      runtimeInputs = [
        fzf
        networkmanager
      ];
      file = ./bin/vpnswitcher.sh;
    })
    (mkScript {
      name = "cnix-update-available";
      runtimeInputs = [ waybar ];
      file = ./bin/cnix-update-available.sh;
    })
    (mkScript {
      name = "choosepaper";
      runtimeInputs = [
        fzf
        swaybg
        pistol
      ];
      file = ./bin/choosepaper.sh;
    })
    (mkScript {
      name = "pwvucontrol-toggle";
      runtimeInputs = [ pwvucontrol ];
      file = ./bin/pwvucontrol-toggle.sh;
    })
    (mkScript {
      name = "calcurse-toggle";
      runtimeInputs = [ calcurse ];
      file = ./bin/calcurse-toggle.sh;
    })
    (mkScript {
      name = "volume-control";
      runtimeInputs = [
        wireplumber
        libnotify
      ];
      file = ./bin/volume-control.sh;
    })
    (mkScript {
      name = "extract";
      runtimeInputs = [
        zip
        unzip
        gnutar
        p7zip
      ];
      file = ./bin/extract.sh;
    })
    (mkScript {
      name = "waybar-systemd";
      runtimeInputs = [ hyprland ];
      file = ./bin/waybar-systemd.sh;
    })
    (mkScript {
      name = "waybar-progress";
      runtimeInputs = [ hyprland ];
      file = ./bin/waybar-progress.sh;
    })
    (mkScript {
      name = "dunst";
      runtimeInputs = [
        hyprland
        dbus
      ];
      file = ./bin/dunst.sh;
    })
    (mkScript {
      name = "mako";
      runtimeInputs = [ hyprland ];
      file = ./bin/mako.sh;
    })
    (mkScript {
      name = "mako-toggle";
      runtimeInputs = [ hyprland ];
      file = ./bin/mako-toggle.sh;
    })
  ];
in
{
  environment.systemPackages = scripts;
}
