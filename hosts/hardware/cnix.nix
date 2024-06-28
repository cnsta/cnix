{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  _nvtop = pkgs.nvtopPackages.amd;
in {
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
      extraPackages = with pkgs; [
        _nvtop
        lact
        libva
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
}
