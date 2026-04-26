{
  settings = {
    accounts = {
      username = "cnst";
      mail = "adam@cnst.dev";
      sshUser = "bunk";
    };

    boot = {
      kernel = {
        variant = "zfsLatest";
        hardware = [ "amd" ];
      };
      loader = {
        default = {
          enable = true;
        };
        lanzaboote = {
          enable = false;
        };
      };
    };

    fonts = {
      enable = true;
    };

    graphics = {
      vendors = [ "amd" ];
    };

    locale = {
      defaultLocale = "en_US.UTF-8";
      enable = true;
      extraLocale = "sv_SE.UTF-8";
      timeZone = "Europe/Stockholm";
    };

    monitors = [
      {
        name = "DP-3";
        width = 2560;
        height = 1440;
        refreshRate = "143.99";
        position = "0x0";
        transform = 0;
        bitDepth = 10;
        workspace = "1";
      }
      {
        name = "HDMI-A-1";
        width = 1920;
        height = 1080;
        refreshRate = "60";
        position = "2560x0";
        # transform = 3;
        workspace = "5";
      }
      {
        name = "eDP-1";
        width = 1920;
        height = 1200;
        refreshRate = "60";
        workspace = "1";
      }
    ];

    network = {
      enable = true;
      tailscale.enable = true;
      bluetooth.enable = true;
      nameservers = [
        "192.168.88.1"
        "192.168.88.69"
      ];
      search = [
        "taila7448a.ts.net"
      ];
      interfaces = {
        "wlp6s0" = {
          allowedTCPPorts = [
            22
            80
            443
          ];
        };
      };
    };

    peripherals = {
      logitech.enable = false;
      kanata.enable = false;
      adb.enable = true;
      yubikey = {
        manager.enable = true;
        touch-detector.enable = true;
      };
      pcscd.enable = true;
      utils.enable = true;
    };

    theme = {
      background = {
        lockscreen = "resadversae_2k";
        primary = "genesis_2k";
      };
    };
  };
}
