let
  hostsDir = ../hosts;
  read = p: builtins.replaceStrings ["\n"] [""] (builtins.readFile p);

  entries = builtins.readDir hostsDir;
  hosts = builtins.filter (n: entries.${n} == "directory") (builtins.attrNames entries);

  keyset = host: let
    u = hostsDir + "/${host}/id_ed25519.pub";
    h = hostsDir + "/${host}/ssh_host_ed25519_key.pub";
  in
    (
      if builtins.pathExists u
      then {user = read u;}
      else {}
    )
    // (
      if builtins.pathExists h
      then {host = read h;}
      else {}
    );
in
  builtins.listToAttrs (map (n: {
      name = n;
      value = keyset n;
    })
    hosts)
