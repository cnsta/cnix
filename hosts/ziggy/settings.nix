{
  settings = {
    accounts = {
      username = "cnst";
      mail = "adam@cnst.dev";
      sshUser = "ziggy";
    };

    boot = {
      kernel = {
        variant = "zfsLatest";
        hardware = [ ];
        extraKernelParams = [ ];
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

    graphics = {
      enable = false;
      vendors = [ ];
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
        "enu1u1" = {
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
  };
}
