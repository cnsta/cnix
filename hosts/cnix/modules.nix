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
        interfaces = {
          "eno1" = {
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
        enable = false;
      };
      blender = {
        enable = false;
        hip = {
          enable = false;
        };
      };
      corectrl = {
        enable = true;
      };
      fish = {
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
      ghostty = {
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
        enable = true;
      };
      microfetch = {
        enable = true;
      };
      pkgs = {
        enable = true;
        desktop = {
          enable = true;
        };
        laptop = {
          enable = false;
        };
        dev = {
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
        enable = false;
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
        enable = false;
      };
    };
    services = {
      agenix = {
        enable = false;
        cnix = {
          enable = false;
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
        enable = true;
        user = "cnst";
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
      polkit = {
        enable = true;
      };
      powerd = {
        enable = false;
      };
      samba = {
        enable = false;
      };
      scx = {
        enable = true;
        scheduler = "scx_lavd";
        flags = "--performance";
      };
      udisks = {
        enable = true;
      };
      zram = {
        enable = true;
      };
    };
    system = {
      fonts = {
        enable = true;
      };
      locale = {
        enable = true;
        defaultLocale = "en_US.UTF-8";
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
