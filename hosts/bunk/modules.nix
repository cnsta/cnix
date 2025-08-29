{
  nixos = {
    boot = {
      kernel = {
        variant = "latest";
        hardware = [ "amd" ];
      };
      loader = {
        default = {
          enable = true;
        };
        lanzaboote = {
          enable = false;
        };
      };
    };
    hardware = {
      bluetooth = {
        enable = true;
      };
      graphics = {
        enable = true;
        vendors = [ "amd" ];
      };
      logitech = {
        enable = false;
      };
      network = {
        enable = true;
        interfaces = {
          "wlp6s0" = {
            allowedTCPPorts = [
              22
              80
              443
            ];
          };
        };
      };
    };
    programs = {
      android = {
        enable = true;
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
        enable = false;
      };
      fish = {
        enable = true;
      };
      gamemode = {
        enable = false;
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
        withUWSM = true;
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
      pkgs = {
        enable = true;
        common = {
          enable = true;
        };
        desktop = {
          enable = false;
        };
        laptop = {
          enable = true;
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
        enable = true;
      };
      obsidian = {
        enable = true;
      };
      steam = {
        enable = false;
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
        enable = true;
        bunk = {
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
        enable = true;
        user = "cnst";
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
      zram = {
        enable = false;
      };
    };
    system = {
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
