{
  config,
  pkgs,
  osConfig,
  lib,
  ...
}: let
  email = config.programs.git.userEmail;
  isCnixpad = osConfig.networking.hostName == "cnixpad";
  isCnixlab = osConfig.networking.hostName == "cnixlab";
  sshKey =
    if isCnixpad
    then "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXCjkKouZrsMoswMIeueO8X/c3kuY3Gb0E9emvkqwUv cnst@cnixpad"
    else if isCnixlab
    then "placeholder text"
    else "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEUub8vbzUn2f39ILhAJ2QeH8xxLSjiyUuo8xvHGx/VB adam@cnst.dev";
in {
  home.packages = [pkgs.gh];
  programs.git = {
    enable = true;
    userName = "cnst";
    userEmail = "adam@cnst.dev";
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
    ${email} namespaces="git" ${sshKey}
  '';
}
