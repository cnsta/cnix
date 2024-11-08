# cnix

My NixOS daily driver. Built primarily for use with
[Hyprland](https://hyprland.org/). Modules keep multiplying, but here are some
prominent tools and apps:

- [Chaotic's Nyx](https://www.nyx.chaotic.cx/) **CachyOS kernel and mesa-git
  things**
- [nh](https://github.com/viperML/nh) **A pretty cool "nix helper"**
- [agenix](https://github.com/ryantm/agenix) **Age-based encryption**
- [kanata](https://github.com/jtroo/kanata) **Keyboard mapping, good stuff**
- [waybar](https://github.com/Alexays/Waybar) **It's a wayland bar!**
- [zen-browser](https://github.com/zen-browser/desktop) **Alpha stage,
  firefox-based browser**
- [helix](https://github.com/helix-editor/helix) **Very quick editor, might
  switch to permanently!**
- [tuirun](https://git.sr.ht/~canasta/tuirun) **Anyrun's applications plugin but
  with tui. WIP, will add more documentation**
- [mako](https://github.com/emersion/mako) **Lightweight notifications**

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
