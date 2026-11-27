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
    settings.locale = {
      defaultLocale = "en_US.UTF-8";
      extraLocale = "sv_SE.UTF-8";
      timeZone = "Europe/Stockholm";
    };

    settings.site = {
      domains = {
        local = "cnix.dev";
        public = "cnst.dev";
      };
      mail = "adam@cnst.dev";
      router = "192.168.88.1";
      dnsVip = "192.168.88.69";
      loginServer = "https://hs.cnst.dev";
      subnets = {
        lan = "192.168.88.0/24";
        podman = "10.88.0.0/16";
        tailnet4 = "100.64.88.0/24";
        tailnet6 = "fd7a:115c:a1e0:88::/64";
      };
    };

    programs = {
      blender = en "k";
      byt = en "kbt";
      gimp = en "k";
      inkscape = en "k";
      lact = en "k";
      nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep 3 --keep-since 21d --keep-one";
        };
      };
      steam = en "kt";
      tmux = en "ks";
      alacritty = when "kbt" {
        enable = true;
        primary = true;
      };
      lutris = en "k";
      chromium = en "kt";
      direnv = en "kbt";
      element-desktop = en "k";
      firefox = en "kt";
      foot = en "kbt";
      fuzzel = en "kbt";
      mpv = en "kbt";
      nvf = en "t";
      yazi = en "kbt";
      zathura = en "kbt";
      fish = en "kbtsz";
      git = all;
      helix = when "kbts" {
        enable = true;
        languages = en "kbts";
        rust = en "kb";
        frontend = en "kt";
      };
      microfetch = all;
      river = en "kbt";
      silt = en "kbts";
      ssh = en "kbt";
      zen-browser = en "kbt";
      # bundles
      pkgs = {
        minimal = en "z";
        common = en "kbts";
        desktop = en "kbt";
        gui = en "kbt";
        server = en "s";
        agent = en "kt";
        dev = {
          common = en "kt";
          php = en "t";
          python = none;
        };
      };
    };

    services = {
      agenix = all;
      ashell = when "kbt" {
        enable = true;
        delta.enable = true;
      };
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
      zram = when {
        "kbtz" = {
          enable = true;
        };
        "s" = {
          enable = true;
          memoryPercent = 15;
        };
      };
      swaybg = en "kbt";
      tailray = en "kbt";
      ntfy-client = en "k";
      udiskie = en "kbt";
      gpg = en "kbt";
      gtk = en "kbt";
      xdg = when {
        "kbt".enable = true;
        "kb".browser = "zen-beta.desktop";
        "t".browser = "firefox.desktop";
      };
    };

    scripts = {
      screenshot = en "k";
      choosepaper = en "kbt";
      pwvucontrol-toggle = en "kbt";
      extract = all;
      update-images = en "sz";
    };
  };
}
