{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cnix.programs.git;
  acct = config.cnix.settings.accounts;
in
{
  options.cnix.programs.git.enable = mkEnableOption "git";

  config = mkIf cfg.enable (mkMerge [
    {
      programs.git = {
        enable = true;
        lfs.enable = true;
      };

      environment.systemPackages = [ pkgs.delta ];

      environment.sessionVariables.DELTA_PAGER = "less -R";
    }

    {
      hjem.users = genAttrs acct.defaultUsers (
        user:
        let
          home = "/home/${user}";
        in
        {
          packages = [ pkgs.gh ];

          xdg.config.files = {
            "git/config" = {
              generator = lib.generators.toGitINI;
              value = {
                user = {
                  name = acct.username;
                  email = acct.mail;
                  signingkey = "${home}/.config/git/allowed_signers";
                };
                signing = {
                  format = "ssh";
                  key = "${home}/.ssh/id_ed25519";
                  signByDefault = true;
                };
                gpg.ssh.allowedSignersFile = "${home}/.config/git/allowed_signers";
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
                core.excludesFile = "${home}/.config/git/ignore";

                pager = {
                  diff = "delta";
                  log = "delta";
                  reflog = "delta";
                  show = "delta";
                };
                interactive.diffFilter = "delta --color-only";
                delta = {
                  dark = true;
                  navigate = true;
                };
              };
            };

            "git/ignore".text = ''
              .direnv
              *result*
            '';

            "git/allowed_signers".text = ''
              ${acct.mail} namespaces="git" ${acct.sshKey}
            '';
          };
        }
      );
    }
  ]);
}
