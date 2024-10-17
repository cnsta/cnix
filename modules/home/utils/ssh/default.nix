{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.utils.ssh;
in {
  options = {
    home.utils.ssh.enable = mkEnableOption "Enables ssh";
  };
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      userKnownHostsFile = "~/.ssh/known_hosts";
    };
  };
}
