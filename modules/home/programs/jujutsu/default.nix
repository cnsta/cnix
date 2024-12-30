{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.home.programs.jujutsu;
in {
  options = {
    home.programs.jujutsu.enable = mkEnableOption "Enables jujutsu";
  };
  config = mkIf cfg.enable {
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          name = config.programs.git.userName;
          email = config.programs.git.userEmail;
        };
        ui = {
          diff-editor = lib.mkIf config.programs.helix.enable [
            "hx"
            "-c"
            "DiffEditor $left $right $output"
          ];
          pager = "less -FRX";
        };
        signing = let
          gitCfg = config.programs.git.extraConfig;
        in {
          backend = "ssh";
          sign-all = true;
          key = gitCfg.signing.key;
        };
        templates = {
          draft_commit_description = ''
            concat(
              description,
              indent("JJ: ", concat(
                "\n",
                "Change summary:\n",
                indent("     ", diff.summary()),
                "\n",
                "Full change:\n",
                indent("     ", diff.git()),
              )),
            )
          '';
        };
      };
    };
  };
}
