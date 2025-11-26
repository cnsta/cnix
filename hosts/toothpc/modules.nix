{
  nixos = {
    boot = {
      kernel = {
        variant = "stable";
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
    hardware = {
      bluetooth = {
        enable = false;
      };
      graphics = {
        enable = true;
        vendors = [ "nvidia" ];
        nvidia = {
          package = "latest";
          open = true;
        };
      };
      network = {
        enable = true;
        tailscale.enable = true;
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
      pkgs = {
        enable = true;
        common = {
          enable = true;
        };
        desktop = {
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
        enable = true;
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
        enable = true;
      };
      thunar = {
        enable = true;
      };
      zsh = {
        enable = true;
      };
    };
    services = {
      agenix = {
        enable = true;
        toothpc = {
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
        user = "toothpick";
      };
      gvfs = {
        enable = true;
      };
      locate = {
        enable = true;
      };
      mullvad = {
        enable = true;
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
        enable = false;
      };
      samba = {
        enable = false;
      };
      udisks = {
        enable = true;
      };
      # xserver = {
      #   videoDrivers = [ "nvidia" ];
      #   xkbLayout = "se";
      # };
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
