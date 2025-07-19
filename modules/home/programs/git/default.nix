{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.git;
in {
  options = {
    home.programs.git.enable = mkEnableOption "Enables git";
  };
  config = mkIf cfg.enable {
    home.packages = [pkgs.gh];
    programs.git = {
      enable = true;
      userName = osConfig.settings.accounts.username;
      userEmail = osConfig.settings.accounts.mail;
      delta = {
        enable = true;
        options.dark = true;
      };
      extraConfig = {
        # user.signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        user.signingkey = "${config.home.homeDirectory}/.config/git/allowed_signers";
        signing = {
          format = lib.mkDefault "ssh";
          key = "${config.home.homeDirectory}/.ssh/id_ed25519";
          signByDefault = true;
        };
        gpg = {
          # format = lib.mkDefault "ssh";
          ssh.allowedSignersFile = config.home.homeDirectory + "/" + config.xdg.configFile."git/allowed_signers".target;
        };
        commit = {
          verbose = true;
          gpgSign = false;
        };
        init.defaultBranch = "main";
        merge.conflictStyle = "diff3";
        diff.algorithm = "histogram";
        log.date = "iso";
        column.ui = "auto";
        branch.sort = "committerdate";
        push.autoSetupRemote = true;
        rerere.enabled = true;
      };
      lfs.enable = true;
      ignores = [
        ".direnv"
        "result"
        ".jj"
      ];
    };
    xdg.configFile."git/allowed_signers".text = ''
      ${osConfig.settings.accounts.mail} namespaces="git" ${osConfig.settings.accounts.sshKey}
    '';
  };
}
