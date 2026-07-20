{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.cnix.scripts;

  mkScript = name: {
    runtimeInputs,
    file,
  }:
    pkgs.writeShellApplication {
      name = "${name}.sh";
      inherit runtimeInputs;
      text = builtins.readFile file;
    };

  scriptDefs = with pkgs; {
    spawn = {
      runtimeInputs = [niri];
      file = ./bin/spawn.sh;
    };

    spawn-or-focus = {
      runtimeInputs = [niri];
      file = ./bin/spawn-or-focus.sh;
    };

    vpnswitcher = {
      runtimeInputs = [
        fzf
        networkmanager
      ];
      file = ./bin/vpnswitcher.sh;
    };

    cnix-update-available = {
      runtimeInputs = [waybar];
      file = ./bin/cnix-update-available.sh;
    };

    choosepaper = {
      runtimeInputs = [
        fzf
        swaybg
        pistol
      ];
      file = ./bin/choosepaper.sh;
    };

    pwvucontrol-toggle = {
      runtimeInputs = [pwvucontrol];
      file = ./bin/pwvucontrol-toggle.sh;
    };

    calcurse-toggle = {
      runtimeInputs = [calcurse];
      file = ./bin/calcurse-toggle.sh;
    };

    volume-control = {
      runtimeInputs = [
        wireplumber
        libnotify
      ];
      file = ./bin/volume-control.sh;
    };

    extract = {
      runtimeInputs = [
        gnutar
        gzip
        bzip2
        xz
        unzip
        unrar
        p7zip
        cpio
        cabextract
        qpdf
      ];
      file = ./bin/extract.sh;
    };

    update-images = {
      runtimeInputs = [podman];
      file = ./bin/update-images.sh;
    };

    waybar-systemd = {
      runtimeInputs = [hyprland];
      file = ./bin/waybar-systemd.sh;
    };

    waybar-progress = {
      runtimeInputs = [hyprland];
      file = ./bin/waybar-progress.sh;
    };

    dunst = {
      runtimeInputs = [
        hyprland
        dbus
      ];
      file = ./bin/dunst.sh;
    };

    mako = {
      runtimeInputs = [hyprland];
      file = ./bin/mako.sh;
    };

    mako-toggle = {
      runtimeInputs = [hyprland];
      file = ./bin/mako-toggle.sh;
    };
  };
in {
  options.cnix.scripts =
    lib.mapAttrs (name: _: {
      enable = lib.mkEnableOption "${name} script";
    })
    scriptDefs;

  config.environment.systemPackages = lib.pipe scriptDefs [
    (lib.filterAttrs (name: _: cfg.${name}.enable))
    (lib.mapAttrsToList mkScript)
  ];
}
