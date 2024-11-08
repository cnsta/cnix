# cnix

Personal NixOS daily driver.

## Structure

Here’s an overview of this repository. Might not be 100 % up to date.

- **`hosts/`** Different hosts go here, easily scalable.
- **`modules/`** Needlessly complicated module system, because it's fun!
  - **`home/`** Home-manager modules.
  - **`nixos/`** Core OS settings and system-wide modules.
  - **`options/`** Options to be leveraged by other modules.
- **`nix/`** Various settings not suitable for modularization, yet.
- **`secrets/`** Agenix secrets.
- **`users/`** Same as hosts but for users! 2:)

## Inspiration

Much credit goes to the folks below, great resources. You'll find I've yanked
quite a few things from them.

- [fufexan](https://github.com/fufexan/dotfiles.git)
- [Misterio77](https://github.com/Misterio77/nix-config.git)
- [NotAShelf](https://github.com/NotAShelf)
