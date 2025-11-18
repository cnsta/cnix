# cnix

My NixOS daily driver. Started as a one machine desktop configuration with
**[Hyprland](https://hyprland.org/)**. Soon modularity became the end goal as
more machines and systems in my home looked primed for NixOS.

Modules keep multiplying, but here are some tools and apps I use:

- **[nh](https://github.com/viperML/nh)** A pretty cool "nix helper".
- **[agenix](https://github.com/ryantm/agenix)** Age based encryption.
- **[kanata](https://github.com/jtroo/kanata)** Keyboard mapping, good stuff.
- **[waybar](https://github.com/Alexays/Waybar)** It's a wayland bar!
- **[zen-browser](https://github.com/zen-browser/desktop)** Beta stage, firefox
  based browser.
- **[fuzzel](https://codeberg.org/dnkl/fuzzel)** App launcher, does what it
  says!
- **[helix](https://github.com/helix-editor/helix)** Neat vim-like editor.
- **[dunst](https://github.com/dunst-project/dunst)** Lightweight notifications
  daemon.
- **[microfetch](https://github.com/NotAShelf/microfetch)** It's neofetch but
  better.

## Hosts

- **bunk** Basic Thinkpad, L13 or something?
- **kima** Main desktop, 9950x, 6950xt.
- **sobotka** Server, 3950x, Intel B580, Radeon Pro W5700.
- **toothpc** Brother's dekstop, Intel CPU, Nvidia GPU.
- **ziggy** Raspberry Pi, running secondary pihole and unbound.

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
