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
        hostName = "adampad";
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
      blueman = {
        enable = true;
      };
      dbus = {
        enable = true;
      };
      fwupd = {
        enable = true;
      };
      gnome-keyring = {
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
      mullvad = {
        enable = true;
      };
      pipewire = {
        enable = true;
      };
      powerd = {
        enable = true;
      };
      samba = {
        enable = false;
      };
      ssh = {
        enable = true;
      };
      udisks = {
        enable = true;
      };
      xserver = {
        amd = {
          enable = true;
        };
      };
    };
    utils = {
      agenix = {
        enable = true;
        adampad = {
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
