{
  nixos = {
    boot = {
      kernel = {
        variant = "latest";
        hardware = [ "amd" ];
        extraKernelParams = [ ];
        amdOverdrive.enable = true;
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
        enable = true;
        vendors = [ "amd" ];
      };
      logitech = {
        enable = true;
      };
      network = {
        enable = true;
        interfaces = {
          "eno1" = {
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
        enable = false;
        withUWSM = false;
      };
      inkscape = {
        enable = false;
      };
      lact = {
        enable = true;
      };
      lutris = {
        enable = false;
      };
      microfetch = {
        enable = true;
      };
      niri = {
        enable = true;
      };
      pkgs = {
        enable = true;
        desktop = {
          enable = true;
        };
        common = {
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
        enable = false;
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
        kima = {
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
      flatpak = {
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
      virtualisation = {
        enable = false;
      };
      locate = {
        enable = true;
      };
      mullvad = {
        enable = true;
      };
      nfs = {
        enable = false;
        server.enable = false;
        client.enable = false;
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
      psd = {
        enable = true;
      };
      samba = {
        enable = false;
      };
      scx = {
        enable = true;
        scheduler = "scx_lavd";
        flags = "--performance";
      };
      tailscale = {
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
