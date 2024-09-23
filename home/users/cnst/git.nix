{
  config,
  pkgs,
  osConfig,
  ...
}: let
  email = config.programs.git.userEmail;
  isCnixpad = osConfig.networking.hostName == "cnixpad";
  sshKey =
    if isCnixpad
    then "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMR2JiKLJMqI48/8lX9ZlG6RYcLMZRYAuk1IpYS72IDD adam@adampad"
    else "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIk/zMuOgZCX+bVCFDHxtoec96RaVfV4iG1Gohp0qHdU cnst@cnix";
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
      user.signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      signing = {
        key = "${config.home.homeDirectory}/.ssh/id_ed25519";
        signByDefault = true;
      };
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = config.home.homeDirectory + "/" + config.xdg.configFile."git/allowed_signers".target;
      };
      commit = {
        verbose = true;
        gpgSign = true;
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
    ${email} namespaces="git" ${sshKey}
  '';
}
