{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  firefoxFlake = inputs.firefox-nightly.packages.${pkgs.stdenv.hostPlatform.system};
  _firefoxNightly = firefoxFlake.firefox-nightly-bin;

  _chromium = pkgs.chromium;

  _floorp = pkgs.floorp-unwrapped;
in {
  home.packages = lib.mkMerge [
    (lib.mkIf (pkgs.hostPlatform.system == "x86_64-linux") (
      with pkgs; [
        # browsers
        _firefoxNightly
        pkgs.firefox-bin
        _chromium
        _floorp
      ]
    ))
  ];
}
