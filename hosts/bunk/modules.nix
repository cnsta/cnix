{
  nixos = {
    boot = {
      kernel = {
        variant = "latest";
        hardware = [ "amd" ];
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
        vendors = [ "amd" ];
      };
      network = {
        enable = true;
        tailscale.enable = true;
        nameservers = [
          "192.168.88.1"
          "192.168.88.69"
        ];
        search = [
          "taila7448a.ts.net"
        ];
        interfaces = {
          "wlp6s0" = {
            allowedTCPPorts = [
              22
              80
              443
            ];
          };
        };
      };
      peripherals = {
        logitech.enable = false;
        kanata.enable = false;
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
      helix = {
        enable = true;
      };
      hyprland = {
        enable = true;
        withUWSM = true;
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
      niri = {
        enable = false;
      };
      pkgs = {
        enable = true;
        gui = {
          enable = true;
        };
        desktop = {
          enable = false;
        };
        laptop = {
          enable = true;
        };
        dev = {
          enable = false;
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
        enable = true;
      };
      obsidian = {
        enable = true;
      };
      steam = {
        enable = false;
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
        bunk = {
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
      fwupd = {
        enable = true;
      };
      gnome = {
        keyring = {
          enable = true;
        };
        evolution-data-server = {
          enable = true;
        };
      };
      greetd = {
        enable = true;
      };
      gvfs = {
        enable = true;
      };
      locate = {
        enable = true;
      };
      mullvad = {
        enable = false;
      };
      nix-ld = {
        enable = false;
      };
      ssh = {
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
        upower.enable = true;
      };
      samba = {
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
        defaultLocale = "en_US.UTF-8";
        enable = true;
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
