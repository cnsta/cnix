# cnixlab

This is my homelab/server setup. It's a young project and big changes are
common. Started as a "fork" of @notthebee's config but has since diverged quite
a bit.

## features

I do like my traefik/unbound "automation" solution; where as I add and test new
services (see /hosts/sobotka/server.nix) domains and dns entries are generated
automatically. This idea stems from @jtojnar's postgres module, which is quite
neat.

Other than that, it's a pretty stock standard NixOS homelab. You'll find native
services, podman containers, your usual arr suite and more.

On the TODO list is adding more monitoring tools and home assistant will surely
make an appearance in the future.
