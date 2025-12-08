{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.nixos.programs.helix;
  helixConfig = pkgs.writeText "config.toml" (builtins.readFile ./config.toml);
  helixLanguages = pkgs.writeText "languages.toml" (builtins.readFile ./languages.toml);
  helixPkg = inputs.helix-flake.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
with lib;
{
  options.nixos.programs.helix = {
    enable = mkEnableOption "Enable the Helix editor";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [
      helixPkg
    ];

    system.activationScripts.homelessHelix = {
      text = ''
        targetDir="/home/$USER/.config/helix"

        mkdir -p "$targetDir"

        ln -sf "${helixConfig}" "$targetDir/config.toml"
        ln -sf "${helixLanguages}" "$targetDir/languages.toml"

        chown -R $USER:users "$targetDir"
      '';
    };
  };
}
