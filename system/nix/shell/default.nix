{pkgs ? import <nixpkgs> {}, ...}: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    nativeBuildInputs = with pkgs; [
      rust-analyzer
      cargo
      clippy
      rustc
      rustfmt
      openssl
      pkg-config
      gtk3
      gtk4
      libadwaita
      glib
      clang
      gnumake
      cmake
      nasm
      perl
    ];
  };
}
