{pkgs, ...}: {
  nixos = {
    boot = {
      loader = {
        default = {
          enable = true;
        };
        lanzaboote = {
          enable = false;
        };
      };
      kernel = {
        variant = "stable";
        hardware = "amd";
        extraKernelParams = [];
        extraBlacklistedModules = [];
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
        enable = false;
      };
      graphics = {
        amd = {
          enable = true;
          extraPackages = true;
          chaotic = {
            enable = false;
            extraPackages = false;
          };
        };
        nvidia = {
          enable = false;
        };
      };
      network = {
        enable = true;
        hostName = "cnixpad";
        interfaces = {
          "wlp6s0" = {
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
        enable = false;
      };
      inkscape = {
        enable = false;
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
          cnixpad = {
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
      };
      system = {
        fwupd = {
          enable = true;
        };
        greetd = {
          enable = true;
          gnomeKeyring.enable = false;
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
          enable = false;
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
      brightnessctl = {
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
          enable = false;
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
      zsh = {
        enable = true;
      };
    };
  };
}
