{
  settings = {
    accounts = {
      username = "cnst";
      mail = "adam@cnst.dev";
      sshUser = "kima";
    };

    boot = {
      kernel = {
        variant = "latest";
        hardware = [ "amd" ];
        extraKernelParams = [ ];
        amdOverdrive.enable = false;
      };
      loader = {
        default = {
          enable = false;
        };
        lanzaboote = {
          enable = true;
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
      enable = true;
      defaultLocale = "en_US.UTF-8";
      extraLocale = "sv_SE.UTF-8";
      timeZone = "Europe/Stockholm";
    };

    monitors = [
      {
        name = "DP-3";
        width = 2560;
        height = 1440;
        refreshRate = "143.99Hz";
        position = "0x0";
        transform = 0;
        # bitDepth = 10;
        workspace = "1";
      }
      {
        name = "HDMI-A-1";
        width = 1920;
        height = 1080;
        refreshRate = "60";
        position = "2560x0";
        transform = 3;
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
        "eno1" = {
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
      kanata.enable = true;
      adb.enable = true;
      yubikey = {
        manager.enable = true;
        touch-detector.enable = true;
      };
      pcscd.enable = true;
      lightcrazy = {
        enable = true;
        service = {
          enable = true;
        };
      };
      utils.enable = true;
    };

    theme = {
      background = {
        lockscreen = "resadversae_2k";
        primary = "ss_parkerabro_2k";
        secondary = "ss_sladda_vert";
      };
    };
  };
}
