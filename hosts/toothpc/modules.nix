{pkgs, ...}: {
  nixos = {
    boot = {
      loader = {
        default = {
          enable = false;
        };
        lanzaboote = {
          enable = true;
        };
      };
      kernel = {
        variant = "stable";
        hardware = "nvidia";
        extraKernelParams = [];
        extraBlacklistedModules = [];
      };
    };
    gaming = {
      steam = {
        enable = true;
      };
      gamescope = {
        enable = true;
      };
      lutris = {
        enable = true;
      };
      gamemode = {
        enable = true;
        optimizeGpu = {
          enable = false;
        };
      };
    };
    gui = {
      gnome = {
        enable = false;
      };
      hyprland = {
        enable = true;
      };
    };
    hardware = {
      bluetooth = {
        enable = false;
      };
      logitech = {
        enable = true;
      };
      graphics = {
        amd = {
          enable = false;
        };
        nvidia = {
          enable = true;
          package = "latest"; # set to beta/latest/stable/production depending on your needs
        };
      };
      network = {
        enable = true;
        hostName = "toothpc";
        interfaces = {
          "enp4s0" = {
            allowedTCPPorts = [22 80 443];
          };
        };
        nm-applet = {
          enable = true;
          indicator = true;
        };
      };
    };
    studio = {
      blender = {
        enable = false;
        hip = {
          enable = false;
        };
      };
      gimp = {
        enable = true;
      };
      inkscape = {
        enable = true;
      };
      beekeeper = {
        enable = true;
      };
      mysql-workbench = {
        enable = true;
      };
    };
    services = {
      network = {
        blueman = {
          enable = false;
        };
        mullvad = {
          enable = true;
        };
        samba = {
          enable = false;
        };
        openssh = {
          enable = true;
        };
      };
      security = {
        agenix = {
          enable = true;
          toothpc = {
            enable = true;
          };
        };
        gnome-keyring = {
          enable = true;
        };
      };
      session = {
        dbus = {
          enable = true;
        };
        dconf = {
          enable = true;
        };
        xserver = {
          videoDrivers = ["nvidia"];
          xkbLayout = "se";
        };
      };
      system = {
        fwupd = {
          enable = true;
        };
        greetd = {
          enable = true;
          gnomeKeyring = {
            enable = false;
          };
          autologin = {
            enable = false;
            user = "toothpick";
          };
        };
        gvfs = {
          enable = true;
        };
        locate = {
          enable = true;
        };
        nix-ld = {
          enable = false;
        };
        pipewire = {
          enable = true;
        };
        powerd = {
          enable = true;
        };
        udisks = {
          enable = true;
        };
        zram = {
          enable = true;
        };
      };
    };
    system = {
      devpkgs = {
        enable = true;
      };
      fonts = {
        enable = true;
      };
      locale = {
        enable = true;
        timeZone = "Europe/Stockholm";
        defaultLocale = "en_US.UTF-8";
        extraLocale = "sv_SE.UTF-8";
      };
      xdg = {
        enable = true;
        xdgOpenUsePortal = true;
      };
    };
    utils = {
      android = {
        enable = false;
      };
      anyrun = {
        enable = true;
      };
      corectrl = {
        enable = false;
      };
      microfetch = {
        enable = true;
      };
      misc = {
        enable = true;
        desktop = {
          enable = true;
        };
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
      yubikey = {
        enable = false;
      };
      obsidian = {
        enable = false;
      };
      zsh = {
        enable = true;
      };
    };
  };
}
