{pkgs ? import <nixpkgs> {}, ...}: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    nativeBuildInputs = with pkgs; [
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
