{pkgs ? import <nixpkgs> {}, ...}: {
  default = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      _rustBuild
    ];
    buildInputs = with pkgs; [
      # rust-bin.stable.latest.default
      openssl
      pkg-config
      ez
      fd
      gtk3
      gtk4
    ];
    shellHook = ''
      alias ls=eza
      alias find=fd
    '';
    RUST_BACKTRACE = 1;
  };
}
