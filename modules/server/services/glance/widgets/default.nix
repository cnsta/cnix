args: {
  serverStats = import ./server-stats.nix args;
  monitors = import ./monitors.nix args;
  containers = import ./containers.nix args;
  wan = import ./wan.nix args;
  speedtest = import ./speedtest.nix args;
  gluetun = import ./gluetun.nix args;
  dns = import ./dns.nix args;
  releases = import ./releases.nix args;
}
