{
  config,
  clib,
  ...
}:
let
  host = config.networking.hostName;
  en = clib.mkEn host;
  when = clib.mkWhen host;
  all = clib.mkAllEn host;
  allWhen = clib.mkAll host;
  none = clib.mkNone host;
in
{
  config.cnix = {
    programs = {
      beekeeper = none;
      blender = en "k";
      byt = en "kbt";
      corectrl = none;
      emacs = en "k";
      gamemode = none;
      gamescope = none;
      gimp = en "k";
      gnome = none;
      hyprland = when "kbt" {
        enable = true;
        withUWSM = true;
      };
      hyprlock = en "kbt";
      inkscape = en "k";
      lact = none;
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
      obsidian = none;
      steam = en "kt";
      tmux = en "ks";
      thunar = none;
      wireshark = none;
      alacritty = when "bt" {
        enable = true;
        primary = true;
      };
      lutris = en "k";
      chromium = en "kt";
      direnv = en "kbt";
      discord = when "kbt" {
        enable = true;
        variant = "vesktop";
      };
      element-desktop = en "k";
      firefox = en "kt";
      floorp = none;
      foot = en "kbt";
      fuzzel = en "kbt";
      ghostty = when "k" {
        enable = true;
        primary = true;
      };
      librewolf = none;
      mpv = en "kbt";
      nvf = en "t";
      # nwg-bar = en "kbt";
      # rofi = none;
      # thunderbird = en "kbt";
      # vscode = en "t";
      # wezterm = none;
      # yazi = en "kbt";
      # zathura = en "kbt";
      zed-editor = none;
      # zellij = none;
      # zsh = none;
      bash = none;
      fish = when "kbtsz" {
        enable = true;
        homeless = en "sz";
      };
      git = all;
      helix = when "kbts" {
        enable = true;
        languages = en "kbts";
        rust = en "kb";
        frontend = en "kt";
      };
      microfetch = all;
      ssh = en "kbt";
      zen-browser = en "kbt";
      # bundles
      pkgs = {
        minimal = en "z";
        common = en "kbts";
        desktop = en "kbt";
        gui = en "kbt";
        server = en "s";
        dev = {
          common = en "kt";
          rust = en "k";
          php = en "t";
          python = none;
        };
      };
    };

    services = {
      agenix = all;
      blueman = none;
      dbus = all;
      flatpak = en "kbt";
      fwupd = en "kbts";
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
      hypridle = en "kbt";
      hyprpaper = en "kbt";
      jellyfin-mpv-shim = none;
      dunst = none;
      quickshell = none;
      syncthing = none;
      tailray = en "kbt";
      udiskie = en "kbt";
      dconf = en "kbt";
      gpg = en "kbt";
      gtk = en "kbt";
      waybar = none;
      xdg = en "kbt";
    };
  };
}
