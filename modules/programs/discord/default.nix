{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cnix.programs.discord;
  acct = config.cnix.settings.accounts;

  # Workaround for https://github.com/GooseMod/OpenAsar/issues/202.
  # Each variant has a default config dir under $XDG_CONFIG_HOME; we point
  # DISCORD_USER_DATA_DIR at it so OpenASAR doesn't get confused.
  variants = {
    stable = {
      dir = "discord";
      package = pkgs.discord;
    };
    ptb = {
      dir = "discordptb";
      package = pkgs.discord-ptb;
    };
    canary = {
      dir = "discordcanary";
      package = pkgs.discord-canary.override { withOpenASAR = true; };
    };
    vesktop = {
      dir = "vesktop";
      package = pkgs.vesktop;
    };
  };

  selected = variants.${cfg.variant};
in
{
  options.cnix.programs.discord = {
    enable = mkEnableOption "Discord";

    variant = mkOption {
      type = types.enum (builtins.attrNames variants);
      default = "stable";
      description = "Discord build to use.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ selected.package ];

      environment.sessionVariables.DISCORD_USER_DATA_DIR = "$HOME/.config/${selected.dir}";
    }

    (mkIf (cfg.variant == "vesktop") {
      hjem.users = genAttrs acct.defaultUsers (_: {
        xdg.config.files."vesktop/themes/base16.css".source = ./base16.css;
      });
    })
  ]);
}
