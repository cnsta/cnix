{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cnix.programs.zen-browser;
in {
  options.cnix.programs.zen-browser.enable = mkEnableOption "Enables zen-browser";

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.symlinkJoin {
        name = "zen-browser-ffmpeg";
        paths = [inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/zen \
            --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [pkgs.ffmpeg]}
        '';
      })
    ];
  };
}
