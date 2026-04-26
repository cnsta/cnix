{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.lutris;
in
{
  options = {
    nixos.programs.lutris.enable = mkEnableOption "Enables lutris";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.lutris.override {
        # Intercept buildFHSEnv to modify target packages
        buildFHSEnv =
          args:
          pkgs.buildFHSEnv (
            args
            // {
              multiPkgs =
                envPkgs:
                let
                  # Fetch original package list
                  originalPkgs = args.multiPkgs envPkgs;

                  # Disable tests for openldap
                  customLdap = envPkgs.openldap.overrideAttrs (_: {
                    doCheck = false;
                  });
                in
                # Replace broken openldap with the custom one
                builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [ customLdap ];
            }
          );
      })
    ];
  };
}
