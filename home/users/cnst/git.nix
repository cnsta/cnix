{
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.git;
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIk/zMuOgZCX+bVCFDHxtoec96RaVfV4iG1Gohp0qHdU cnst@cnix";
in {
  home.packages = [pkgs.gh];
  programs.git = {
    enable = true;
    userName = "cnst";
    userEmail = "adamhilmersson@gmail.com";
    delta = {
      enable = true;
      options.dark = true;
    };
    extraConfig = {
      signing = {
        key = "${config.home.homeDirectory}/.ssh/id_ed25519";
        signByDefault = true;
      };
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = config.home.homeDirectory + "/" + config.xdg.configFile."git/allowed_signers".target;
      };
      init.defaultBranch = "main";
      # commit.gpgSign = lib.mkDefault true;

      merge.conflictStyle = "diff3";
      commit.verbose = true;
      diff.algorithm = "histogram";
      log.date = "iso";
      column.ui = "auto";
      branch.sort = "committerdate";
      # Automatically track remote branch
      push.autoSetupRemote = true;
      # Reuse merge conflict fixes when rebasing
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
    ${cfg.userEmail} namespaces="git" ${sshKey}
  '';
}
