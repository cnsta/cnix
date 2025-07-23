{
  nixos = {
    boot = {
      kernel = {
        variant = "latest";
        hardware = ["amd"];
        extraKernelParams = [];
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
        vendors = ["amd"];
      };
      logitech = {
        enable = true;
      };
      network = {
        enable = true;
        extraHosts = ''
          192.168.88.14 sobotka
          192.168.88.14 cnst.dev
          192.168.88.14 lidarr.cnst.dev
          192.168.88.14 radarr.cnst.dev
          192.168.88.14 sonarr.cnst.dev
          192.168.88.14 prowlarr.cnst.dev
          192.168.88.14 bazarr.cnst.dev
          192.168.88.14 qbt.cnst.dev
          192.168.88.14 jellyseerr.cnst.dev
          192.168.88.14 jellyfin.cnst.dev
          192.168.88.14 uptime.cnst.dev
          192.168.88.14 pihole.cnst.dev
        '';
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
      lact = {
        enable = true;
      };
      lutris = {
        enable = false;
      };
      microfetch = {
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
        enable = true;
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
      nfs = {
        enable = true;
        server.enable = false;
        client.enable = true;
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
