{
  cnix.settings = {
    accounts = {
      username = "toothpick";
      mail = "fredrik@libellux.com";
    };

    boot = {
      kernel = {
        variant = "latest";
        extraBlacklistedModules = ["ucsi_ccg" "i2c_nvidia_gpu"];
      };
      loader = {
        lanzaboote = {
          enable = true;
        };
      };
    };

    graphics = {
      vendors = ["nvidia"];
      nvidia = {
        package = "latest";
        open = true;
      };
    };

    monitors = [
      {
        name = "DVI-D-1";
        width = 1920;
        height = 1080;
        refreshRate = "144";
        position = "0x0";
        transform = 0;
      }
    ];

    network = {
      enable = true;
      tailscale.enable = true;
      interfaces = {
        "enp4s0" = {
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
      logitech.enable = true;
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
