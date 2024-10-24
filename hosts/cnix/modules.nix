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
        variant = "cachyos";
        hardware = "amd";
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
          enable = true;
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
        enable = true;
      };
      logitech = {
        enable = true;
      };
      graphics = {
        amd = {
          enable = true;
          extraPackages = false;
          chaotic = {
            enable = true;
            extraPackages = true;
          };
        };
        nvidia = {
          enable = false;
        };
      };
      network = {
        enable = true;
        hostName = "cnix";
        interfaces = {
          "enp7s0" = {
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
        enable = true;
        hip = {
          enable = true;
        };
      };
      gimp = {
        enable = true;
      };
      inkscape = {
        enable = true;
      };
      beekeeper = {
        enable = false;
      };
      mysql-workbench = {
        enable = false;
      };
    };
    services = {
      network = {
        blueman = {
          enable = true;
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
          cnix = {
            enable = true;
          };
        };
        gnome-keyring = {
          enable = false;
        };
      };
      session = {
        dbus = {
          enable = true;
        };
        dconf = {
          enable = true;
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
            user = "cnst";
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
        pcscd = {
          enable = true;
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
        kanata = {
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
        extraPortals = [pkgs.xdg-desktop-portal-gtk];
      };
    };
    utils = {
      android = {
        enable = true;
      };
      anyrun = {
        enable = false;
      };
      corectrl = {
        enable = true;
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
      obsidian = {
        enable = true;
      };
      yubikey = {
        enable = true;
      };
      zsh = {
        enable = true;
      };
    };
  };
}
