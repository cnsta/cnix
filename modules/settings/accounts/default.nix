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

  keyName =
    if cfg.sshUser != null
    then cfg.sshUser
    else config.networking.hostName;

  selectedKey =
    userKeys.${keyName}
      or (abort "accounts: no user key for ${keyName} in secrets/keys.nix");
in {
  options.cnix.settings.accounts = {
    username = mkOption {
      type = types.str;
      default = "cnst";
      description = "Set the desired username";
    };

    mail = mkOption {
      type = types.str;
      default = "adam@cnst.dev";
      description = "Set the desired email";
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

    sshKey = mkOption {
      type = types.str;
      default = selectedKey;
      readOnly = true;
      description = "This host's SSH public key, read from hosts/<name>/id_ed25519.pub";
    };

    sshKeys = mkOption {
      type = types.attrsOf types.str;
      default = hostKeys;
      readOnly = true;
      description = "All hosts' SSH public keys, keyed by host directory name";
    };

    sshUser = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Override which hosts/<name> key to use (defaults to networking.hostName)";
    };

    domains = mkOption {
      type = types.submodule {
        options = {
          local = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The local domain of the host";
          };
          public = mkOption {
            type = types.str;
            default = "example.com";
            description = "The public domain of the host";
          };
        };
      };
    };
  };

  config = mkIf (cfg.terminal != null) {
    environment.sessionVariables.TERMINAL = getExe cfg.terminal;
  };
}
