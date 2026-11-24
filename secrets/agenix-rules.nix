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
  "vaultwardenEnvironment.age".publicKeys = sobotka;
  "cloudflareFirewallApiKey.age".publicKeys = sobotka;
  "vaultwardenCloudflared.age".publicKeys = sobotka;
  "cloudflareDnsApiToken.age".publicKeys = sobotka;
  "cloudflareDnsCredentials.age".publicKeys = sobotka;
  "wgCredentials.age".publicKeys = sobotka;
  "wgSobotkaPrivateKey.age".publicKeys = sobotka;
  "gluetunQbtEnvironment.age".publicKeys = sobotka;
  "gluetunSlskdEnvironment.age".publicKeys = sobotka;
  "gluetunDispatcharrEnvironment.age".publicKeys = sobotka;
  "gluetunArrEnvironment.age".publicKeys = sobotka;
  "gluetunSearxngEnvironment.age".publicKeys = sobotka;
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
  "mailRedisPw.age".publicKeys = sobotka;
  "mailRspamdCtrlPw.age".publicKeys = sobotka;
  "immichOidcSecret.age".publicKeys = sobotka;
  "forgejoCloudflared.age".publicKeys = sobotka;
  "autheliaCloudflared.age".publicKeys = sobotka;
  "grafanaSecretKey.age".publicKeys = sobotka;
  "grafanaOidcSecret.age".publicKeys = sobotka;
  "smtp.age".publicKeys = sobotka;
  "flaresolverrEnvironment.age".publicKeys = sobotka;
  "prowlarrEnvironment.age".publicKeys = sobotka;
  "sonarrEnvironment.age".publicKeys = sobotka;
  "radarrEnvironment.age".publicKeys = sobotka;
  "bazarrEnvironment.age".publicKeys = sobotka;
  "sabnzbdEnvironment.age".publicKeys = sobotka;
  "qbtEnvironment.age".publicKeys = sobotka;
  "minifluxEnvironment.age".publicKeys = sobotka;
  "minifluxPgPwd.age".publicKeys = sobotka;
  "ntfyEnvironment.age".publicKeys = sobotka;
  "harmoniaSignKey.age".publicKeys = sobotka;
  "headscaleOidc.age".publicKeys = sobotka;
  "headplaneEnv.age".publicKeys = sobotka;
  "jellyfinEnvironment.age".publicKeys = sobotka;
  "jellyfinCloudflared.age".publicKeys = sobotka;
  "fluxerEnvironment.age".publicKeys = sobotka;
  "glanceEnvironment.age".publicKeys = sobotka;
  "speedtestEnvironment.age".publicKeys = sobotka;
  "dispatcharrEnvironment.age".publicKeys = sobotka;
  "dispatcharrCloudflared.age".publicKeys = sobotka;
  "aurralEnvironment.age".publicKeys = sobotka;

  # kima-specific
  "ntfyClientToken.age".publicKeys = kima;

  # ziggy-specific
  "cloudflareDnsCredentialsZiggy.age".publicKeys = ziggy;
  "ziggyPihole.age".publicKeys = ziggy;
  "hsPreauth.age".publicKeys = sobotka;

  # sobotka + ziggy
  "keepalived.age".publicKeys = sobotka ++ ziggy;
  "traefikEnv.age".publicKeys = sobotka ++ ziggy;

  # toothpc-specific
  "toothpcSmbCredentials.age".publicKeys = toothpc;
}
