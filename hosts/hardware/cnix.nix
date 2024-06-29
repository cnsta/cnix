{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  zramSwap.enable = true;

  security.rtkit.enable = true;
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        lact
        libva
        vaapiVdpau
        libvdpau-va-gl
        vkd3d
        vkd3d-proton
      ];
    };
  };
}
