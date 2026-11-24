{pkgs, ...}: {
  cnix.settings = {
    boot = {
      kernel = {
        variant = "latest";
        amdOverdrive.enable = true;
      };
      loader = {
        lanzaboote = {
          enable = true;
        };
      };
    };

    graphics = {
      vendors = ["amd"];
    };

    monitors = [
      {
        name = "DP-1";
        width = 2560;
        height = 1440;
        refreshRate = "144";
        customMode = false;
        adaptiveSync = false;
        position = "0x0";
        transform = 0;
        bitDepth = 8;
        hdr = false;
      }
      {
        name = "HDMI-A-1";
        wallpaper = "secondary";
        width = 1920;
        height = 1080;
        refreshRate = "60";
        position = "2560x0";
        transform = 3;
      }
    ];

    network = {
      enable = true;
      tailscale.enable = true;
      bluetooth.enable = true;
      interfaces = {
        "eno1" = {
          allowedTCPPorts = [22];
        };
      };
    };

    nix = {
      enable = true;
      cpuWeight = 20;
      ioWeight = 20;
      allowedCPUs = "0-27";
    };

    peripherals = {
      kanata.enable = true;
      adb.enable = true;
      yubikey = {
        manager.enable = true;
        touch-detector.enable = true;
      };
      pcscd.enable = true;
      libinput.enable = true;
      litecrazy = {
        enable = true;
        service = {
          enable = true;
          browser = pkgs.chromium;
          batteryInterval = 180;
          lowBatteryThreshold = 20;
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
