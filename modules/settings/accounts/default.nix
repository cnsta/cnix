{
  lib,
  config,
  self,
  ...
}:
with lib; let
  cfg = config.cnix.settings.accounts;

  keys = import "${self}/secrets/keys.nix";
  userKeys = mapAttrs (_: v: v.user) (filterAttrs (_: v: v ? user) keys);
in {
  options.cnix.settings.accounts = {
    username = mkOption {
      type = types.str;
      default = "cnst";
      description = "Set the desired username";
    };

    mail = mkOption {
      type = types.str;
      default = config.cnix.settings.site.mail;
      defaultText = lib.literalExpression "config.cnix.settings.site.mail";
      description = "The user's mail (git identity).";
    };

    terminal = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = "Primary terminal package for the host";
    };

    defaultUsers = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Users that hjem manages on this host";
      example = ["cnst"];
    };

    sshKeys = mkOption {
      type = types.attrsOf types.str;
      default = userKeys;
      readOnly = true;
      description = "All hosts' SSH public keys, keyed by host directory name";
    };
  };

  config = mkIf (cfg.terminal != null) {
    environment.sessionVariables.TERMINAL = getExe cfg.terminal;
  };
}
