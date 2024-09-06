# cnix nix

**cnix** began as a direct copy-paste of Misterio's starter configs, but over
time it evolved to resemble his main configuration more closely. I gradually
integrated elements from other excellent resources, such as colemickens' and
fufexan's configurations, and eventually gained enough knowledge to start
creating my own solutions.

What you’ll find here is my daily driver and a work in progress, with many
components still heavily inspired by the repositories mentioned below. I
strongly encourage you to visit these repositories if you're looking for
inspiration.

This Nix configuration aims to be modular and scalable—something it achieves to
some extent, though much work remains. The core of the system is a modular setup
with separate configurations for users and systems, managed through
`modules.nix` files in the `hosts` and `users` directories. I'm currently
developing a small app to make managing these configurations more user-friendly.

The three configurations below have been a major source of inspiration. They
each take a unique approach to flake setup, and I highly recommend checking them
out!

- [fufexan](https://github.com/fufexan/dotfiles.git)
- [colemickens](https://github.com/colemickens/nixcfg.git)
- [Misterio77](https://github.com/Misterio77/nix-config.git)
