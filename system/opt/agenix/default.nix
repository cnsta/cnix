{inputs, ...}: {
  environment.systemPackages = [inputs.agenix.packages.x86_64-linux.default];
}
