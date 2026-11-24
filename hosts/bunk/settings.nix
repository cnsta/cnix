{config, ...}: {
  cnix.settings = {
    boot = {
      kernel = {
        variant = "latest";
      };
      loader = {
        default = {
          enable = true;
        };
      };
    };

    graphics = {
      vendors = ["amd"];
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
      }
      {
        name = "HDMI-A-1";
        width = 1920;
        height = 1080;
        refreshRate = "60";
        position = "2560x0";
        # transform = 3;
      }
      {
        name = "eDP-1";
        width = 1920;
        height = 1200;
        refreshRate = "60";
      }
    ];

    network = {
      enable = true;
      tailscale.enable = true;
      bluetooth.enable = true;
      nameservers = with config.cnix.settings.site; [router dnsVip];
      search = [
        "stalk-regulus.ts.net"
      ];
      interfaces = {
        "wlp6s0" = {
          allowedTCPPorts = [22];
        };
      };
    };

    nix = {
      enable = true;
      cpuWeight = 20;
      ioWeight = 20;
      allowedCPUs = "0-5";
    };

    peripherals = {
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
