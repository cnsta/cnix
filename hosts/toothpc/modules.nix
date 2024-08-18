{
  modules = {
    network = {
      enable = true;
      hostName = "toothpc";
      interfaces = {
        "enp4s0" = {
          allowedTCPPorts = [22 80 443];
        };
      };
    };
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
    utils = {
      android.enable = false;
      anyrun.enable = true;
      corectrl.enable = true;
      microfetch.enable = true;
      nix-ld.enable = false;
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
      sops.enable = false;
      ssh.enable = true;
      udisks.enable = true;
      xserver.nvidia.enable = true;
    };
    hardware = {
      bluetooth.enable = false;
      logitech.enable = true;
      graphics = {
        amd.enable = false;
        nvidia.enable = true;
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
  };
}
