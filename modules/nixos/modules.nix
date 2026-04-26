{ config, clib, ... }:
let
  host = config.networking.hostName;
  en = clib.mkEn host;
  when = clib.mkWhen host;
  all = clib.mkAllEn host;
  allWhen = clib.mkAll host;
  none = clib.mkNone host;
in
{
  nixos = {
    programs = {
      beekeeper = none;
      blender = en "k";
      corectrl = none;
      emacs = en "k";
      fish = {
        enable = true;
        homeless = en "sz";
      };
      gamemode = none;
      gamescope = none;
      gimp = en "k";
      git = all;
      gnome = none;
      helix = all;
      hyprland = when "kbt" {
        enable = true;
        withUWSM = true;
      };
      inkscape = en "k";
      lact = none;
      lutris = en "k";
      microfetch = all;
      mysql-workbench = none;
      nh = allWhen {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep 3 --keep-since 21d";
        };
      };
      niri = none;
      npm = none;
      nushell = none;
      obsidian = none;
      pkgs = {
        common = all;
        desktop = en "kbt";
        gui = en "kbt";
        dev = {
          common = en "k";
          rust = en "k";
          python = en "k";
        };
      };
      steam = en "kt";
      thunar = none;
      wireshark = en "k";
      zsh = none;
    };

    services = {
      agenix = all;
      blueman = none;
      dbus = all;
      dconf = en "kbt";
      flatpak = en "kbt";
      fwupd = all;
      gnome = when "kbt" {
        keyring.enable = true;
        evolution-data-server.enable = true;
      };
      greetd = en "kbt";
      gvfs = en "kbt";
      locate = all;
      mullvad = none;
      nfs = none;
      pipewire = en "kbt";
      polkit = en "kbt";
      power = when "kbt" {
        enable = true;
        upower.enable = true;
      };
      psd = en "k";
      samba = none;
      scx = when "k" {
        enable = true;
        scheduler = "scx_lavd";
        flags = "--performance";
      };
      ssh = all;
      udisks = en "kbt";
      virtualisation = none;
      zram = all;
    };
  };
}
