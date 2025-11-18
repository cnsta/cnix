# cnix

My NixOS daily driver. Started as a one machine desktop configuration with
**[Hyprland](https://hyprland.org/)**. Soon modularity became the end goal as
more machines and systems in my home looked primed for NixOS.

Modules keep multiplying, but here are some tools and apps I use:

- **[nh](https://github.com/viperML/nh)** _A pretty cool "nix helper"._
- **[agenix](https://github.com/ryantm/agenix)** _Age based encryption._
- **[kanata](https://github.com/jtroo/kanata)** _Keyboard mapping, good stuff._
- **[waybar](https://github.com/Alexays/Waybar)** _It's a wayland bar!_
- **[zen-browser](https://github.com/zen-browser/desktop)** _Beta stage, firefox
  based browser._
- **[fuzzel](https://codeberg.org/dnkl/fuzzel)** _App launcher, does what it
  says!_
- **[helix](https://github.com/helix-editor/helix)** _Neat vim-like editor._
- **[dunst](https://github.com/dunst-project/dunst)** _Lightweight notifications
  daemon._
- **[microfetch](https://github.com/NotAShelf/microfetch)** _It's neofetch but
  better._

## Hosts

- **bunk** _Basic Thinkpad, L13 or something?_
- **kima** _Main desktop, 9950x, 6950xt._
- **sobotka** _Server, 3950x, Intel B580, Radeon Pro W5700._
- **toothpc** _Brother's dekstop, Intel CPU, Nvidia GPU._
- **ziggy** _Raspberry Pi, running secondary pihole and unbound._

## Structure

Here’s an overview of this repository. Might not be 100 % up to date.

```
┌─hosts/       # Different hosts go here, easily scalable.
├┬modules/     # Needlessly complicated module system, because it's fun!
│├─home/       # Home-manager modules.
│├─nixos/      # Core OS settings and system-wide modules.
│├─server/     # All things homelab. Recent project, code messy but working.
│└─settings/   # Options to be leveraged by other modules.
├─nix/         # Various settings not suitable for modularization, yet.
├─secrets/     # Agenix secrets.
└─users/       # Same as hosts but for users! 2:)
```

## Inspiration

Much credit goes to the folks below, great resources. You'll find I've yanked
quite a few things from them.

- **[fufexan](https://github.com/fufexan/dotfiles.git)**
- **[Misterio77](https://github.com/Misterio77/nix-config.git)**
- **[NotAShelf](https://github.com/NotAShelf)**
