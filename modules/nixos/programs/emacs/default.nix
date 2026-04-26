# copying https://github.com/hlissner/dotfiles/blob/master/modules/editors/emacs.nix
# verbatim while taking emacs for a test run.
{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixos.programs.emacs;
  emacs =
    with pkgs;
    (emacsPackagesFor emacs-git-pgtk).emacsWithPackages (
      epkgs: with epkgs; [
        vterm
        mu4e
      ]
    );
in
{
  options = {
    nixos.programs.emacs.enable = mkEnableOption "Enables anyrun";
  };
  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      inputs.emacs-overlay.overlays.default
    ];

    user.packages = with pkgs; [
      ## Emacs itself
      binutils # native-comp needs 'as', provided by this
      emacs # HEAD + native-comp

      ## Doom dependencies
      git
      ripgrep
      gnutls # for TLS connectivity

      ## Optional dependencies
      fd # faster projectile indexing
      imagemagick # for image-dired
      (mkIf (config.programs.gnupg.agent.enable) pinentry-emacs) # in-emacs gnupg prompts
      zstd # for undo-fu-session/undo-tree compression

      ## Module dependencies
      # :email mu4e
      mu
      isync
      # :checkers spell
      (aspellWithDicts (
        ds: with ds; [
          en
          en-computers
          en-science
        ]
      ))
      # :emacs dired +dirvish
      ffmpegthumbnailer
      mediainfo
      vips
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      sqlite
      # :lang cc
      clang-tools
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      # :lang nix
      age
      # :lang python
      ty
    ];

    environment.variables.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];
  };
}
