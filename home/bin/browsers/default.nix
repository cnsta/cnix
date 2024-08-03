{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  firefoxFlake = inputs.firefox-nightly.packages.${pkgs.stdenv.hostPlatform.system};
  _firefoxNightly = firefoxFlake.firefox-nightly-bin;

  _chromium = pkgs.ungoogled-chromium;
  # _mullvad = pkgs.mullvad-browser;
in {
  home.packages = lib.mkMerge [
    (lib.mkIf (pkgs.hostPlatform.system == "x86_64-linux") (
      with pkgs; [
        # browsers
        _firefoxNightly
        pkgs.firefox-bin
        # _chromium
      ]
    ))
  ];
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions = [
      "gebbhagfogifgggkldgodflihgfeippi" # return youtube dislike
      "mnjggcdmjocbbbhaepdhchncahnbgone" # sponsorblock for youtube
      "ponfpcnoihfmfllpaingbgckeeldkhle" # enhancer for youtube
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    ];
  };
}
