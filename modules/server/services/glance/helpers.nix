{
  config,
  lib,
  clib,
}: rec {
  mkIcon = icon: let
    prefixed = builtins.match "(sh|si|di|mdi)-(.+)" icon;
    parts = lib.splitString "." icon;
    ext = lib.last parts;
    base = lib.concatStringsSep "." (lib.init parts);
  in
    if icon == ""
    then null
    else if lib.hasPrefix "http" icon
    then icon
    else if prefixed != null
    then "${builtins.elemAt prefixed 0}:${builtins.elemAt prefixed 1}"
    else if builtins.length parts > 1
    then "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/${ext}/${base}.${ext}"
    else "di:${icon}";

  getDomain = s: clib.server.mkHostDomain config s;
  publicUrl = s: "https://${s.subdomain}.${getDomain s}${s.dashboard.path}";
}
