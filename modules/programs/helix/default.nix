# modules/programs/helix/default.nix
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    genAttrs
    ;
  cfg = config.cnix.programs.helix;
  acct = config.cnix.settings.accounts;

  helixPkg = inputs.helix-flake.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  options.cnix.programs.helix.enable = mkEnableOption "the Helix editor";

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ helixPkg ];
      environment.variables.EDITOR = "hx";
    }

    (mkIf (acct.defaultUsers != [ ]) {
      hjem.users = genAttrs acct.defaultUsers (_: {
        xdg.config.files = {
          "helix/config.toml".source = ./config.toml;
          "helix/languages.toml".source = ./languages.toml;
        };
      });
    })
  ]);
}
