{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.cnix.programs.git;
  acct = config.cnix.settings.accounts;

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
        package = pkgs.git.override {withLibsecret = true;};
        lfs.enable = true;
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
