{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;

  sshKeys = {
    bunk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXCjkKouZrsMoswMIeueO8X/c3kuY3Gb0E9emvkqwUv cnst@cnixpad";
    sobotka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICiNcNex+/hrEQJYJJTj89uPXocSfChU38E5TujWdxaM cnstlab@cnixlab";
    kima = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEUub8vbzUn2f39ILhAJ2QeH8xxLSjiyUuo8xvHGx/VB adam@cnst.dev";
    toothpc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGu5vZbb5ExampleKeyHereGfDF9c5 toothpick@toothpc";
  };

  keyName = config.settings.accounts.sshUser or null;

  selectedKey =
    if keyName != null
    then
      lib.attrByPath [keyName] (
        builtins.abort "No SSH key defined for hostname/key '${toString keyName}'"
      )
      sshKeys
    else builtins.abort "No accounts.sshUser provided, cannot select SSH key.";
in {
  options.settings.accounts = {
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
    sshKey = lib.mkOption {
      type = lib.types.str;
      default = selectedKey;
      description = "Host-specific SSH key";
      readOnly = true;
    };
    sshUser = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Optional override for selecting an SSH key by name";
    };
  };
}
