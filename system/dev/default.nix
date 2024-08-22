{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [inputs.fenix.overlays.default];
  environment.systemPackages = with pkgs; [
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly

    # Wayland-specific dependencies
    wayland # Wayland client library
    wayland-protocols # Wayland protocols (essential for building against Wayland)
    pkg-config # Helps to manage libraries during compilation

    # Aquamarine: Hyprland's new compositor library
    aquamarine # Aquamarine compositor library for Wayland

    # Other utilities and tools
    openssl # Required for some crates that involve networking or encryption
    alejandra
    nixd
    pyright
    yaml-language-server
    lua-language-server
  ];
}
