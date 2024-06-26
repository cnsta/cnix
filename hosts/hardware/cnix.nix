{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  _nvtop = pkgs.nvtopPackages.amd;
in
{
  zramSwap.enable = true;

  security.rtkit.enable = true;
  hardware = {
    pulseaudio.enable = false;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        _nvtop
        lact
        libva
        vaapiVdpau
        libvdpau-va-gl
        gamescope
      ];
    };
  };
}
