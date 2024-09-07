{
  modules = {
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
        ssh = {
          enable = true;
        };
      };
      security = {
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
        };
        gvfs = {
          enable = true;
        };
        locate = {
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
          enable = false;
        };
      };
    };
    utils = {
      agenix = {
        enable = true;
        cnixpad = {
          enable = true;
        };
      };
      android = {
        enable = true;
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
      nix-ld = {
        enable = false;
      };
      misc = {
        enable = true;
      };
      npm = {
        enable = true;
      };
    };
  };
}