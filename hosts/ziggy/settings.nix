{
  cnix.settings = {
    boot = {
      kernel = {
        variant = "stable";
      };
      loader = {
        extlinux = {
          enable = true;
        };
      };
    };

    fonts = {
      enable = false;
    };

    graphics.vendors = [];

    network = {
      enable = true;
      interfaces = {
        "enu1u1" = {
          allowedTCPPorts = [
            22
            8053
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
      buildDevice = "/dev/mmcblk0";
      ioWriteBandwidthMax = "10M";
      ioWriteIOPSMax = "500";
    };
  };
}
