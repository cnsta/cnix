{
  config,
  lib,
  pkgs,
  self,
  ...
}:
with lib; let
  cfg = config.cnix.programs.git;
  acct = config.cnix.settings.accounts;

  allowedSigners =
    concatMapStringsSep "\n"
    (key: ''${acct.mail} namespaces="git" ${key}'')
    (attrValues acct.sshKeys)
    + "\n";

  treefmt =
    (self.inputs.treefmt-nix.lib.evalModule pkgs (import "${self}/treefmt.nix")).config.build.wrapper;

  preCommit = pkgs.writeShellScript "pre-commit" ''
    set -euo pipefail

    root="$(git rev-parse --show-toplevel)"
    [ -e "$root/treefmt.nix" ] || [ -e "$root/.treefmt.toml" ] || [ -e "$root/treefmt.toml" ] || exit 0

    mapfile -t files < <(git diff --cached --name-only --diff-filter=ACMR)
    [ "''${#files[@]}" -eq 0 ] && exit 0

    if ! ${treefmt}/bin/treefmt --no-cache --fail-on-change -- "''${files[@]}"; then
      echo >&2 "treefmt reformatted staged files — restage and commit again:"
      echo >&2 "  git add -u && git commit"
      exit 1
    fi
  '';

  gitHooks = pkgs.linkFarm "git-hooks" [
    {
      name = "pre-commit";
      path = preCommit;
    }
  ];
in {
  options.cnix.programs.git.enable = mkEnableOption "git";

  config = mkIf cfg.enable (mkMerge [
    {
      programs.git = {
        enable = true;
        lfs.enable = true;
        package = pkgs.git.override {
          withLibsecret = true;
          doInstallCheck = false;
        };
      };

      environment.systemPackages = [pkgs.delta treefmt];
      environment.sessionVariables.DELTA_PAGER = "less -R";
    }

    {
      hjem.users = genAttrs acct.defaultUsers (
        user: let
          home = "/home/${user}";
        in {
          packages = [pkgs.gh];

          files = {
            ".config/git/config" = {
              generator = lib.generators.toGitINI;
              value = {
                user = {
                  name = acct.username;
                  email = acct.mail;
                  signingkey = "${home}/.ssh/id_ed25519.pub";
                };
                gpg = {
                  format = "ssh";
                  ssh.allowedSignersFile = "${home}/.config/git/allowed_signers";
                };
                commit = {
                  verbose = true;
                  gpgsign = true;
                };
                tag.gpgsign = true;
                credential.helper = "libsecret";
                init.defaultBranch = "main";
                merge.conflictStyle = "diff3";
                diff.algorithm = "histogram";
                log.date = "iso";
                column.ui = "auto";
                branch.sort = "committerdate";
                push.autoSetupRemote = true;
                rerere.enabled = true;
                core = {
                  excludesFile = "${home}/.config/git/ignore";
                  hooksPath = "${gitHooks}";
                };
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
              clobber = true;
            };

            ".config/git/ignore" = {
              text = ''
                .direnv
                *result*
              '';
              clobber = true;
            };

            ".config/git/allowed_signers" = {
              text = allowedSigners;
              clobber = true;
            };
          };
        }
      );
    }
  ]);
}
