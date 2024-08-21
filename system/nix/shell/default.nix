{pkgs ? import <nixpkgs> {}, ...}: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    nativeBuildInputs = with pkgs; [
      rust-analyzer # Rust language server for code completion and analysis
      cargo # Rust package manager and build tool
      rustc # Rust compiler
      clippy # Linter to catch common mistakes in Rust code
      rustfmt # Tool to format Rust code according to style guidelines

      # Wayland-specific dependencies
      wayland # Wayland client library
      wayland-protocols # Wayland protocols (essential for building against Wayland)
      pkg-config # Helps to manage libraries during compilation

      # Aquamarine: Hyprland's new compositor library
      aquamarine # Aquamarine compositor library for Wayland

      # Other utilities and tools
      openssl # Required for some crates that involve networking or encryption
      git # Version control system, useful for development
    ];
    shellHook = ''
      # Set SHELL to zsh if available
      export SHELL=$(which zsh)
      # Optionally, start zsh directly if it's not the current shell
      if [ "$SHELL" != "$(which zsh)" ]; then
        exec $SHELL
      fi
    '';
  };
}
