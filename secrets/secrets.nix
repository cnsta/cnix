let
  keys = import ./keys.nix;
  forHost = h: builtins.attrValues (keys.${h} or {});

  kima = forHost "kima";
  bunk = forHost "bunk";
  sobotka = forHost "sobotka";
  ziggy = forHost "ziggy";
  toothpc = forHost "toothpc";

  all = kima ++ bunk ++ sobotka ++ ziggy ++ toothpc;
in {
  # sobotka-specific
  "cloudflareEnvironment.age".publicKeys = sobotka;
  "vaultwardenEnvironment.age".publicKeys = sobotka;
  "homepageEnvironment.age".publicKeys = sobotka;
  "cloudflareFirewallApiKey.age".publicKeys = sobotka;
  "vaultwardenCloudflared.age".publicKeys = sobotka;
  "nextcloudCloudflared.age".publicKeys = sobotka;
  "nextcloudAdminPass.age".publicKeys = sobotka;
  "cloudflareDnsApiToken.age".publicKeys = sobotka;
  "cloudflareDnsCredentials.age".publicKeys = sobotka;
  "wgCredentials.age".publicKeys = sobotka;
  "wgSobotkaPrivateKey.age".publicKeys = sobotka;
  "gluetunQbtEnvironment.age".publicKeys = sobotka;
  "gluetunSlskdEnvironment.age".publicKeys = sobotka;
  "gluetunSearxngEnvironment.age".publicKeys = sobotka;
  "gluetunArrEnvironment.age".publicKeys = sobotka;
  "sobotkaPihole.age".publicKeys = sobotka;
  "slskd.age".publicKeys = sobotka;
  "wwwCloudflared.age".publicKeys = sobotka;
  "lldapAdminPassword.age".publicKeys = sobotka;
  "lldapJwt.age".publicKeys = sobotka;
  "lldapKeySeed.age".publicKeys = sobotka;
  "autheliaSession.age".publicKeys = sobotka;
  "autheliaStorage.age".publicKeys = sobotka;
  "autheliaJwt.age".publicKeys = sobotka;
  "autheliaPostgres.age".publicKeys = sobotka;
  "autheliaOidcHmac.age".publicKeys = sobotka;
  "autheliaOidcIssuerPem.age".publicKeys = sobotka;
  "turnstoneEnvironment.age".publicKeys = sobotka;
  "mailRedisPw.age".publicKeys = sobotka;
  "mailRspamdCtrlPw.age".publicKeys = sobotka;
  "immichOidcSecret.age".publicKeys = sobotka;
  "forgejoOidcSecret.age".publicKeys = sobotka;
  "memosOidcSecret.age".publicKeys = sobotka;
  "autheliaCloudflared.age".publicKeys = sobotka;
  "grafanaSecretKey.age".publicKeys = sobotka;
  "matrixCloudflared.age".publicKeys = sobotka;
  "continuwuityLiveKit.age".publicKeys = sobotka;
  "continuwuityEnvironment.age".publicKeys = sobotka;
  "continuwuityToml.age".publicKeys = sobotka;
  "livekitEnvironment.age".publicKeys = sobotka;
  "livekitYaml.age".publicKeys = sobotka;
  "cinnyJson.age".publicKeys = sobotka;
  "searxngEnvironment.age".publicKeys = sobotka;
  "flaresolverrEnvironment.age".publicKeys = sobotka;
  "octofiestaEnvironment.age".publicKeys = sobotka;
  "prowlarrEnvironment.age".publicKeys = sobotka;
  "sonarrEnvironment.age".publicKeys = sobotka;
  "radarrEnvironment.age".publicKeys = sobotka;
  "lidarrEnvironment.age".publicKeys = sobotka;
  "sportarrEnvironment.age".publicKeys = sobotka;
  "sabnzbdEnvironment.age".publicKeys = sobotka;
  "qbtEnvironment.age".publicKeys = sobotka;
  "quiEnvironment.age".publicKeys = sobotka;
  "minifluxEnvironment.age".publicKeys = sobotka;
  "minifluxPgPwd.age".publicKeys = sobotka;
  "harmoniaSignKey.age".publicKeys = sobotka;
  "headscaleOidc.age".publicKeys = sobotka;
  "headplaneEnv.age".publicKeys = sobotka;
  "tailscaleOidcSecret.age".publicKeys = sobotka;
  "jellyfinEnvironment.age".publicKeys = sobotka;

  # ziggy-specific
  "cloudflareDnsCredentialsZiggy.age".publicKeys = ziggy;
  "ziggyPihole.age".publicKeys = ziggy;
  "hsPreauth.age".publicKeys = sobotka;

  # sobotka + ziggy
  "keepalived.age".publicKeys = sobotka ++ ziggy;
  "tsAuth.age".publicKeys = sobotka ++ ziggy;
  "traefikEnv.age".publicKeys = sobotka ++ ziggy;

  # toothpc-specific
  "smb-credentials.age".publicKeys = toothpc;
}
