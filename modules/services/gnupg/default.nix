{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.cnix.services.gpg;
in {
  options.cnix.services.gpg.enable =
    mkEnableOption "GnuPG with SSH agent emulation and gnome3 pinentry";

  config = lib.mkIf cfg.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    environment.systemPackages = [pkgs.gnupg];
  };
}
