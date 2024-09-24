{
  modules = {
    boot = {
      loader = {
        default.enable = false;
        lanzaboote.enable = true;
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
        xserver = {
          amd = {
            hhkbse = {
              enable = true;
            };
          };
          nvidia = {
            enable = false;
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
      };
    };
    utils = {
      android = {
        enable = true;
      };
      anyrun = {
        enable = true;
      };
      chaotic = {
        enable = true;
        amd = {
          enable = true;
        };
      };
      corectrl = {
        enable = true;
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
        enable = true;
      };
    };
  };
}
