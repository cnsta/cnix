{
  modules = {
    gaming = {
      steam.enable = true;
      gamescope.enable = true;
      lutris.enable = true;
      gamemode = {
        enable = true;
        optimizeGpu = false;
      };
    };
    gui = {
      gnome.enable = false;
      hyprland.enable = true;
    };
    hardware = {
      bluetooth.enable = false;
      logitech.enable = true;
      graphics = {
        amd.enable = false;
        nvidia = {
          enable = true;
          package = "beta"; # set to stable or beta depending on preference
        };
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
    studio = {
      blender = {
        enable = false;
        hip = false;
      };
      gimp.enable = true;
      inkscape.enable = true;
    };
    sysd = {
      blueman.enable = false;
      dbus.enable = true;
      fwupd.enable = true;
      gnome-keyring.enable = true;
      greetd.enable = true;
      gvfs.enable = true;
      locate.enable = true;
      mullvad.enable = true;
      pipewire.enable = true;
      powerd.enable = true;
      samba.enable = false;
      sops = {
        enable = false;
        toothpc = false;
      };
      ssh.enable = true;
      udisks.enable = true;
      xserver.nvidia.enable = true;
    };
    utils = {
      android.enable = true;
      anyrun.enable = true;
      corectrl.enable = false;
      microfetch.enable = true;
      nix-ld.enable = false;
    };
  };
}
