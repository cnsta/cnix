{
  config,
  lib,
  pkgs,
  outputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    concatStringsSep
    flatten
    ;
  cfg = config.cnix.programs.ssh;

  hostnames = builtins.attrNames outputs.nixosConfigurations;
  hostPatterns = concatStringsSep " " (
    flatten (
      map (h: [
        h
        "${h}.local"
      ]) hostnames
    )
  );

  matchBlock = ''
    Match host ${hostPatterns}
        StreamLocalBindUnlink yes
        ForwardAgent yes
        ForwardX11 yes
        ForwardX11Trusted yes
        SetEnv WAYLAND_DISPLAY=wayland-waypipe
        SetEnv TERM=xterm-256color
  '';
in
{
  options.cnix.programs.ssh.enable = mkEnableOption "ssh client config";

  config = mkIf cfg.enable {
    programs.ssh = {
      extraConfig = matchBlock;
      enableAskPassword = true;
      askPassword = "${pkgs.gcr_4}/libexec/gcr4-ssh-askpass";
    };
  };
}
