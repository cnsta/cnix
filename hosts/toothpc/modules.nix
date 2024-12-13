{
  nixos = {
    boot = {
      kernel = {
        extraBlacklistedModules = [];
        extraKernelParams = [];
        hardware = "nvidia";
        variant = "latest";
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
        enable = false;
      };
      graphics = {
        amd = {
          enable = false;
        };
        nvidia = {
          enable = true;
          package = "beta";
          open = {
            enable = true;
          };
        };
      };
      logitech = {
        enable = true;
      };
      network = {
        enable = true;
        interfaces = {
          "enp4s0" = {
            allowedTCPPorts = [22 80 443];
          };
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
        enable = true;
      };
      blender = {
        enable = false;
        hip = {
          enable = false;
        };
      };
      brightnessctl = {
        enable = false;
      };
      corectrl = {
        enable = false;
      };
      gamemode = {
        enable = true;
        optimizeGpu = {
          enable = false;
        };
      };
      gamescope = {
        enable = false;
      };
      gimp = {
        enable = false;
      };
      gnome = {
        enable = false;
      };
      hyprland = {
        enable = true;
      };
      inkscape = {
        enable = false;
      };
      lutris = {
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
      mysql-workbench = {
        enable = true;
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
      thunar = {
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
        toothpc = {
          enable = true;
        };
      };
      blueman = {
        enable = false;
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
        enable = true;
        user = "toothpick";
      };
      gvfs = {
        enable = true;
      };
      kanata = {
        enable = false;
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
      polkit = {
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
      xserver = {
        videoDrivers = ["nvidia"];
        xkbLayout = "se";
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
