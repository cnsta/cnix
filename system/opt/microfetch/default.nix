{inputs, ...}: {
  environment.systemPackages = [inputs.microfetch.packages.x86_64-linux.default];
}
