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
          package = "production"; # set to beta/stable/production depending on your needs
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
    };
    sysd = {
      blueman = {
        enable = false;
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
        nvidia = {
          enable = true;
        };
      };
    };
    utils = {
      agenix = {
        enable = true;
        toothpc = {
          enable = true;
        };
      };
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
