{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

let
  firefoxFlake = inputs.firefox-nightly.packages.${pkgs.stdenv.hostPlatform.system};
  _firefoxNightly = firefoxFlake.firefox-nightly-bin;

  _chrome = pkgs.google-chrome.override { commandLineArgs = [ "--force-dark-mode" ]; };
in
{
  home.packages = lib.mkMerge [
    (lib.mkIf (pkgs.hostPlatform.system == "x86_64-linux") (
      with pkgs;
      [
        # browsers
        _firefoxNightly
        pkgs.firefox-bin
        _chrome
      ]
    ))
  ];
}
