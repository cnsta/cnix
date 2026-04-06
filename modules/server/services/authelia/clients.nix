{
  config,
  lib,
  clib,
  self,
  ...
}:
let
  services = config.server.services;

  readSecret =
    name: lib.removeSuffix "\n" (builtins.readFile (self + "/secrets/${name}OidcSecret.txt"));

  mkClient =
    {
      client_id,
      service,
      client_name ? client_id,
      redirect_paths ? [ ],
      redirect_uris ? [ ],
      authorization_policy ? "default",
      require_pkce ? true,
      token_endpoint_auth_method ? "client_secret_basic",
      scopes ? [
        "openid"
        "email"
        "profile"
        "groups"
      ],
      response_types ? [ "code" ],
      extra ? { },
    }:
    let
      baseUrl = clib.server.mkFullDomain config service;
    in
    {
      inherit
        client_id
        client_name
        authorization_policy
        require_pkce
        token_endpoint_auth_method
        scopes
        response_types
        ;
      client_secret = readSecret client_id;
      public = false;
      consent_mode = "implicit";
      pkce_challenge_method = if require_pkce then "S256" else "";
      grant_types = [ "authorization_code" ];
      userinfo_signed_response_alg = "none";
      redirect_uris = (map (p: "https://${baseUrl}/${p}") redirect_paths) ++ redirect_uris;
    }
    // extra;

in
{
  services.authelia.instances.main.settings.identity_providers.oidc.clients = [
    (mkClient {
      client_id = "immich";
      client_name = "Immich";
      service = services.immich;
      redirect_paths = [
        "auth/login"
        "user-settings"
      ];
      redirect_uris = [ "app.immich:///oauth-callback" ];
      require_pkce = false;
      token_endpoint_auth_method = "client_secret_post";
    })

    # (mkClient {
    #   client_id = "forgejo";
    #   client_name = "Forgejo";
    #   service = services.forgejo;
    #   redirect_paths = [ "user/oauth2/authelia/callback" ];
    # })
  ];
}
