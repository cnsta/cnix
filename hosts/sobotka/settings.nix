{
  settings = {
    accounts = {
      username = "cnst";
      mail = "adam@cnst.dev";
      sshUser = "sobotka";
      domains = {
        local = "cnix.dev";
        public = "cnst.dev";
      };
    };

    boot = {
      kernel = {
        variant = "zfsLatest";
        hardware = [ "amd" ];
        extraKernelParams = [ ];
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
      enable = false;
    };

    graphics = {
      vendors = [
        "intel"
        "amd"
      ];
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
      interfaces = {
        "enp6s0" = {
          allowedTCPPorts = [
            22
            80
            443
            8090
          ];
          allowedUDPPorts = [
            58846
            6881
          ];
        };
      };
    };

    peripherals = {
      logitech.enable = false;
      kanata.enable = false;
      adb.enable = false;
      yubikey = {
        manager.enable = false;
        touch-detector.enable = false;
      };
      pcscd.enable = true;
      utils.enable = true;
    };
  };
}
