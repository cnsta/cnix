{
  modules = {
    boot = {
      loader = {
        default.enable = true;
        lanzaboote.enable = false;
      };
      kernel = {
        variant = "latest";
        hardware = "amd";
        extraKernelParams = [];
        extraBlacklistedModules = [];
      };
    };
    gaming = {
      steam = {
        enable = false;
      };
      gamescope = {
        enable = false;
      };
      lutris = {
        enable = false;
      };
      gamemode = {
        enable = false;
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
        enable = true;
      };
      logitech = {
        enable = false;
      };
      graphics = {
        amd = {
          enable = true;
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
    sysd = {
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
        xserver = {
          amd = {
            enable = true;
          };
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
    utils = {
      android = {
        enable = true;
      };
      anyrun = {
        enable = true;
      };
      brightnessctl = {
        enable = true;
      };
      chaotic = {
        enable = false;
        amd = {
          enable = false;
        };
      };
      corectrl = {
        enable = false;
      };
      microfetch = {
        enable = true;
      };
      misc = {
        enable = true;
        desktop.enable = false;
      };
      npm = {
        enable = true;
      };
    };
  };
}
