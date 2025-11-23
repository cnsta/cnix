{
  nixos = {
    boot = {
      kernel = {
        variant = "latest";
        hardware = [ "amd" ];
        extraKernelParams = [ ];
        amdOverdrive.enable = true;
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
    hardware = {
      bluetooth = {
        enable = true;
      };
      graphics = {
        enable = true;
        vendors = [ "amd" ];
      };
      network = {
        enable = true;
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
        logitech.enable = true;
        kanata.enable = true;
        adb.enable = true;
        yubikey = {
          manager.enable = true;
          touch-detector.enable = true;
        };
        pcscd.enable = true;
        utils.enable = true;
      };
    };
    programs = {
      beekeeper = {
        enable = false;
      };
      blender = {
        enable = false;
        hip = {
          enable = false;
        };
      };
      corectrl = {
        enable = false;
      };
      fish = {
        enable = true;
      };
      gamemode = {
        enable = true;
        optimizeGpu = {
          enable = true;
        };
      };
      gamescope = {
        enable = false;
      };
      gimp = {
        enable = true;
      };
      gnome = {
        enable = false;
      };
      hyprland = {
        enable = true;
        withUWSM = true;
      };
      inkscape = {
        enable = true;
      };
      lact = {
        enable = true;
      };
      lutris = {
        enable = false;
      };
      microfetch = {
        enable = true;
      };
      niri = {
        enable = false;
      };
      pkgs = {
        enable = true;
        desktop = {
          enable = true;
        };
        common = {
          enable = true;
        };
        laptop = {
          enable = false;
        };
        dev = {
          enable = true;
        };
      };
      mysql-workbench = {
        enable = false;
      };
      nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep 3 --keep-since 21d";
        };
      };
      npm = {
        enable = false;
      };
      obsidian = {
        enable = true;
      };
      steam = {
        enable = true;
      };
      thunar = {
        enable = false;
      };
      zsh = {
        enable = false;
      };
    };
    services = {
      agenix = {
        enable = true;
        kima = {
          enable = true;
        };
      };
      blueman = {
        enable = true;
      };
      dbus = {
        enable = true;
      };
      dconf = {
        enable = true;
      };
      flatpak = {
        enable = true;
      };
      fwupd = {
        enable = true;
      };
      gnome-keyring = {
        enable = false;
      };
      greetd = {
        enable = true;
        user = "cnst";
      };
      gvfs = {
        enable = true;
      };
      virtualisation = {
        enable = false;
      };
      locate = {
        enable = true;
      };
      mullvad = {
        enable = false;
      };
      nfs = {
        enable = false;
        server.enable = false;
        client.enable = false;
      };
      nix-ld = {
        enable = false;
      };
      openssh = {
        enable = true;
      };
      pipewire = {
        enable = true;
      };
      polkit = {
        enable = true;
      };
      power = {
        enable = true;
        powertop.enable = false;
        powerProfilesDaemon.enable = false;
        upower.enable = true;
      };
      psd = {
        enable = true;
      };
      samba = {
        enable = false;
      };
      scx = {
        enable = true;
        scheduler = "scx_lavd";
        flags = "--performance";
      };
      tailscale = {
        enable = true;
      };
      udisks = {
        enable = true;
      };
      zram = {
        enable = true;
      };
    };
    system = {
      fonts = {
        enable = true;
      };
      locale = {
        enable = true;
        defaultLocale = "en_US.UTF-8";
        extraLocale = "sv_SE.UTF-8";
        timeZone = "Europe/Stockholm";
      };
      xdg = {
        enable = true;
        xdgOpenUsePortal = true;
      };
    };
  };
}
