{
  cnix.settings = {
    boot = {
      kernel = {
        variant = "stable";
        extraKernelParams = ["zfs.zfs_arc_max=34359738368"];
      };
      loader = {
        default = {
          enable = true;
        };
      };
    };

    fonts = {
      enable = false;
    };

    graphics = {
      vendors = [
        "intel"
        "amd"
      ];
    };

    network = {
      enable = true;
      bluetooth.enable = true;
      interfaces = {
        "enp6s0" = {
          allowedTCPPorts = [
            22
            80
            443
          ];
        };
      };
    };

    nix = {
      enable = true;
      cpuWeight = 30;
      cpuQuota = "2400%";
      memoryHigh = "32G";
      memoryMax = "40G";
      maxJobs = 4;
      cores = 6;
      buildDevice = "/dev/nvme0n1";
      ioWriteBandwidthMax = "200M";
      ioWriteIOPSMax = "20000";
    };

    peripherals = {
      pcscd.enable = true;
      utils.enable = true;
    };
  };
}
