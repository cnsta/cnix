{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.home.programs.helix;
in
with lib;
{
  options = {
    home.programs.helix.enable = mkEnableOption "Enable helix";
  };

  config = mkIf cfg.enable {
    programs.helix = {
      enable = true;
      package = inputs.helix-flake.packages.${pkgs.stdenv.hostPlatform.system}.default;

      settings = builtins.fromTOML (builtins.readFile ./config.toml);
      languages = builtins.fromTOML (builtins.readFile ./languages.toml);
    };
  };
}
