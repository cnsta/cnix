{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.ssh;
in {
  options = {
    home.programs.ssh.enable = mkEnableOption "Enables ssh";
  };
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      userKnownHostsFile = "~/.ssh/known_hosts";
    };
  };
}
