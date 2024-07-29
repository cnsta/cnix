{
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      AllowUsers = ["toothpick" "cnst"];
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}
