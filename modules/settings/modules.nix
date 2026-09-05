{
  config,
  clib,
  ...
}: let
  inherit (clib) all none;
  host = config.networking.hostName;
  en = clib.mkEn host;
  when = clib.mkWhen host;
in {
  config.cnix = {
    programs = {
      beekeeper = none;
      blender = en "k";
      byt = en "kbt";
      corectrl = none;
      gamemode = none;
      gamescope = none;
      gimp = en "k";
      gnome = none;
      inkscape = en "k";
      lact = en "k";
      maccel = en "k";
      mysql-workbench = none;
      nh = {
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
      ## pnpm unsafe, install flatpak
      # discord = when "kbt" {
      #   enable = true;
      #   variant = "vesktop";
      # };
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
      river = en "k";
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
      ashell = when "k" {
        enable = true;
        delta.enable = true;
      };
      blueman = none;
      cifs = when {
        "t" = {
          enable = true;
          shares."/mnt/share".device = "//192.168.88.223/libellux";
        };
      };
      dbus = all;
      flatpak = en "kbt";
      fwupd = en "kbts";
      gnome = when "kbt" {
        keyring.enable = true;
        gvfs.enable = true;
      };
      greetd = en "kbt";
      locate = en "kbts";
      mullvad = none;
      nfs = none;
      openssh = all;
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
      udisks = en "kbt";
      virtualisation = none;
      zram = all;
      dunst = none;
      syncthing = none;
      swaybg = en "k";
      swayidle = none;
      tailray = en "kbt";
      udiskie = en "kbt";
      dconf = en "kbt";
      gpg = en "kbt";
      gtk = en "kbt";
      waybar = none;
      xdg = en "kbt";
    };

    scripts = {
      niri-autostack = none;
      niri-spawn-or-focus = none;
      screenshot = en "k";
      vpnswitcher = none;
      cnix-update-available = none;
      choosepaper = en "kbt";
      pwvucontrol-toggle = en "kbt";
      calcurse-toggle = en "k";
      volume-control = none;
      extract = all;
      update-images = en "sz";
      waybar-systemd = none;
      waybar-progress = none;
      dunst = none;
      mako = none;
      mako-toggle = none;
    };
  };
}
