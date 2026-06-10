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
    mkMerge
    concatStringsSep
    genAttrs
    ;

  cfg = config.cnix.programs.ssh;
  acct = config.cnix.settings.accounts;

  hostnames = builtins.filter (h: h != config.networking.hostName) (
    builtins.attrNames outputs.nixosConfigurations
  );
  hostPatterns = concatStringsSep "," hostnames;

  sshConfig = ''
    Match host ${hostPatterns}
      StreamLocalBindUnlink yes
      ForwardAgent yes
      SetEnv WAYLAND_DISPLAY=wayland-waypipe TERM=xterm-256color

    Host *
      ServerAliveInterval 60
      ServerAliveCountMax 3
      HashKnownHosts no
      UserKnownHostsFile ~/.ssh/known_hosts
      AddKeysToAgent yes
      IdentitiesOnly yes
      ControlMaster auto
      ControlPath ~/.ssh/sockets/%r@%h-%p
      ControlPersist 10m
      SetEnv TERM=xterm-256color
  '';
in
{
  options.cnix.programs.ssh.enable = mkEnableOption "ssh client config";

  config = mkIf cfg.enable (mkMerge [
    {
      programs.ssh = {
        enableAskPassword = true;
        askPassword = "${pkgs.gcr_4}/libexec/gcr4-ssh-askpass";
      };
    }

    (mkIf (acct.defaultUsers != [ ]) {
      hjem.users = genAttrs acct.defaultUsers (_: {
        files = {
          ".ssh/config".text = sshConfig;
        };
      });
    })
  ]);
}
