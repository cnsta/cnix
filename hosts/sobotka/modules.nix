{
  nixos = {
    boot = {
      kernel = {
        variant = "latest";
        hardware = ["amd"];
        extraKernelParams = [];
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
        enable = false;
      };
      graphics = {
        enable = true;
        vendors = [
          "intel"
          "amd"
        ];
      };
      logitech = {
        enable = false;
      };
      network = {
        enable = true;
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
    };
    programs = {
      android = {
        enable = false;
      };
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
        homeless.enable = true;
      };
      gamemode = {
        enable = false;
        optimizeGpu = {
          enable = false;
        };
      };
      gamescope = {
        enable = false;
      };
      gimp = {
        enable = false;
      };
      gnome = {
        enable = false;
      };
      hyprland = {
        enable = false;
      };
      inkscape = {
        enable = false;
      };
      lutris = {
        enable = false;
      };
      microfetch = {
        enable = true;
      };
      pkgs = {
        enable = true;
        desktop = {
          enable = false;
        };
        common = {
          enable = false;
        };
        laptop = {
          enable = false;
        };
        server = {
          enable = true;
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
          extraArgs = "--keep 9 --keep-since 51d";
        };
      };
      npm = {
        enable = false;
      };
      obsidian = {
        enable = false;
      };
      steam = {
        enable = false;
      };
      thunar = {
        enable = false;
      };
      yubikey = {
        enable = false;
      };
      zsh = {
        enable = false;
      };
    };
    services = {
      agenix = {
        enable = true;
        sobotka = {
          enable = true;
        };
      };
      blueman = {
        enable = false;
      };
      dbus = {
        enable = true;
      };
      dconf = {
        enable = false;
      };
      flatpak = {
        enable = false;
      };
      fwupd = {
        enable = true;
      };
      gnome-keyring = {
        enable = false;
      };
      greetd = {
        enable = false;
        user = "cnst";
      };
      gvfs = {
        enable = false;
      };
      kanata = {
        enable = false;
      };
      locate = {
        enable = true;
      };
      mullvad = {
        enable = true;
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
      pcscd = {
        enable = false;
      };
      pipewire = {
        enable = false;
      };
      polkit = {
        enable = false;
      };
      powerd = {
        enable = false;
      };
      samba = {
        enable = false;
      };
      scx = {
        enable = false;
        scheduler = "scx_lavd";
        flags = "--performance";
      };
      tailscale = {
        enable = false;
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
        enable = false;
        xdgOpenUsePortal = true;
      };
    };
  };
}
