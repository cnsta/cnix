{
  settings = {
    accounts = {
      username = "toothpick";
      mail = "fredrik@libellux";
      sshUser = "toothpc";
    };

    boot = {
      kernel = {
        variant = "zfsLatest";
        hardware = [ "nvidia" ];
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
      vendors = [ "nvidia" ];
      nvidia = {
        package = "beta";
        open = true;
      };
    };

    locale = {
      defaultLocale = "en_US.UTF-8";
      enable = true;
      extraLocale = "sv_SE.UTF-8";
      timeZone = "Europe/Stockholm";
    };

    monitors = [
      {
        name = "DVI-D-1";
        width = 1920;
        height = 1080;
        refreshRate = "144";
        position = "0x0";
        transform = 0;
        workspace = "1";
      }
    ];

    network = {
      enable = true;
      tailscale.enable = true;
      bluetooth.enable = false;
      interfaces = {
        "enp4s0" = {
          allowedTCPPorts = [
            22
            80
            443
          ];
        };
      };
    };

    peripherals = {
      logitech.enable = true;
      kanata.enable = false;
      adb.enable = false;
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
