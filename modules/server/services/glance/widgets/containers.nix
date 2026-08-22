{
  lib,
  srv,
  unit,
  helpers,
  ...
}: let
  inherit (helpers) mkIcon publicUrl;

  podmanSocket = "/run/podman/podman.sock";

  visible = lib.filterAttrs (name: s: name != unit && s.enable) srv.services;

  containerised =
    lib.filterAttrs (_: s: s.dashboard.container.name != "") visible;

  mkContainerEntries = _name: s: let
    cname = s.dashboard.container.name;

    parent = {
      "${cname}" =
        lib.filterAttrs (_: v: v != null) {
          name = s.dashboard.name;
          url = publicUrl s;
          icon = mkIcon s.dashboard.icon;
          hide = false;
        }
        // lib.optionalAttrs (s.dashboard.container.children != {}) {
          id = cname;
        };
    };

    children =
      lib.mapAttrs (_: label: {
        name = label;
        parent = cname;
        hide = false;
      })
      s.dashboard.container.children;
  in
    parent // children;

  containers =
    lib.foldl' (a: b: a // b) {}
    (lib.mapAttrsToList mkContainerEntries containerised);
in
  lib.optional (containers != {}) {
    type = "docker-containers";
    title = "Containers";
    "sock-path" = podmanSocket;
    # only show what we've declared, keeps pod infra containers out of the way.
    "hide-by-default" = true;
    "running-only" = false;
    inherit containers;
  }
