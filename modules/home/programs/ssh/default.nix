{
  outputs,
  config,
  lib,
  ...
}:
let
  nixosConfigs = builtins.attrNames outputs.nixosConfigurations;
  homeConfigs = map (n: lib.last (lib.splitString "@" n)) (
    builtins.attrNames outputs.homeConfigurations
  );
  hostnames = lib.unique (homeConfigs ++ nixosConfigs);

  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.ssh;
in
{
  options = {
    home.programs.ssh.enable = mkEnableOption "Enables ssh";
  };
  config = mkIf cfg.enable {
    programs.ssh = {
      matchBlocks = {
        net = {
          host = lib.concatStringsSep " " (
            lib.flatten (
              map (host: [
                host
                "${host}.local"
              ]) hostnames
            )
          );
          extraOptions.StreamLocalBindUnlink = "yes";
          forwardAgent = true;
          forwardX11 = true;
          forwardX11Trusted = true;
          setEnv.WAYLAND_DISPLAY = "wayland-waypipe";
        };
      };
    };
  };
}
