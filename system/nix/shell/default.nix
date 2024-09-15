{pkgs ? import <nixpkgs> {}, ...}: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

    nativeBuildInputs = with pkgs; [
      # Build tools
      cmake # Build system generator
      gnumake # GNU Make
      pkg-config # Manages library paths during compilation
      perl # Scripting language, sometimes needed during builds

      # Version control
      git # Version control system

      # Auto-patching (include if needed)
      autoPatchelfHook # Automatically patches ELF binaries

      # Scripting languages (include if needed)
      # nodejs       # JavaScript runtime environment
    ];

    buildInputs = with pkgs; [
      # Graphics and UI libraries
      aquamarine # Aquamarine compositor library for Wayland
      egl-wayland # EGLStream-based Wayland platform
      wayland # Wayland client library
      wayland-protocols # Wayland protocols for Wayland applications

      # Cryptography
      openssl # TLS/SSL library for networking and encryption
    ];

    shellHook = ''
      # Set LD_LIBRARY_PATH if needed (temporary fix)
      # export LD_LIBRARY_PATH="${pkgs.openssl.out}/lib:$LD_LIBRARY_PATH"

      # Set SHELL to zsh if available
      export SHELL=$(which zsh)
      if [ "$SHELL" != "$(which zsh)" ]; then
        exec $SHELL
      fi
    '';
  };
}
