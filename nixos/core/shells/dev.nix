{pkgs ? import <nixpkgs> {}, ...}: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
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
    ];
  };
}
