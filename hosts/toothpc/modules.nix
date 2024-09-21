{
  modules = {
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
          package = "beta"; # set to beta/stable/production depending on your needs
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
    sysd = {
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
        ssh = {
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
          nvidia = {
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
        desktop.enable = true;
      };
      npm = {
        enable = true;
      };
      yubikey = {
        enable = false;
      };
    };
  };
}
