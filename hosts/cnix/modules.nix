{
  nixos = {
    boot = {
      kernel = {
        extraBlacklistedModules = [];
        extraKernelParams = [];
        hardware = "amd";
        variant = "cachyos";
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
        enable = true;
      };
      graphics = {
        amd = {
          enable = true;
          packageSet = "chaotic";
        };
        nvidia = {
          enable = false;
        };
      };
      logitech = {
        enable = true;
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
    programs = {
      android = {
        enable = true;
      };
      anyrun = {
        enable = false;
      };
      beekeeper = {
        enable = false;
      };
      blender = {
        enable = true;
        hip = {
          enable = true;
        };
      };
      brightnessctl = {
        enable = false;
      };
      corectrl = {
        enable = true;
      };
      gamemode = {
        enable = true;
        optimizeGpu = {
          enable = true;
        };
      };
      gamescope = {
        enable = true;
      };
      gimp = {
        enable = true;
      };
      gnome = {
        enable = false;
      };
      hyprland = {
        enable = true;
      };
      inkscape = {
        enable = true;
      };
      lutris = {
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
      mysql-workbench = {
        enable = false;
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
      yubikey = {
        enable = true;
      };
      zsh = {
        enable = true;
      };
    };
    services = {
      agenix = {
        enable = true;
        cnix = {
          enable = true;
        };
      };
      blueman = {
        enable = true;
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
        autologin = {
          enable = false;
          user = "cnst";
        };
        enable = true;
        gnomeKeyring = {
          enable = false;
        };
      };
      gvfs = {
        enable = true;
      };
      kanata = {
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
      pcscd = {
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
      udisks = {
        enable = true;
      };
      zram = {
        enable = true;
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
