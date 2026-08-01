{
  cnix.settings = {
    accounts = {
      username = "cnst";
      mail = "adam@cnst.dev";
      sshUser = "ziggy";
      domains = {
        local = "cnix.dev";
        public = "cnst.dev";
      };
    };

    boot = {
      kernel = {
        variant = "zfsLatest";
        hardware = [];
        extraKernelParams = [];
      };
      loader = {
        default = {
          enable = false;
        };
        extlinux = {
          enable = true;
        };
        lanzaboote = {
          enable = false;
        };
      };
    };

    fonts = {
      enable = false;
    };

    locale = {
      enable = true;
      defaultLocale = "en_US.UTF-8";
      extraLocale = "sv_SE.UTF-8";
      timeZone = "Europe/Stockholm";
    };

    network = {
      enable = true;
      tailscale.enable = false;
      bluetooth.enable = false;
      localIp = "192.168.88.12";
      interfaces = {
        "enu1u1" = {
          allowedTCPPorts = [
            22
            8053
          ];
          allowedUDPPorts = [
          ];
        };
      };
    };

    nix = {
      enable = true;
      cpuWeight = 20;
      cpuQuota = "200%";
      memoryHigh = "256M";
      memoryMax = "384M";
      maxJobs = 1;
      cores = 2;
      ioWriteBandwidthMax = ["/dev/mmcblk0 10M"];
      ioWriteIOPSMax = ["/dev/mmcblk0 500"];
    };

    peripherals = {
      logitech.enable = false;
      kanata.enable = false;
      adb.enable = false;
      yubikey = {
        manager.enable = false;
        touch-detector.enable = false;
      };
      pcscd.enable = false;
      utils.enable = false;
    };
  };
}
