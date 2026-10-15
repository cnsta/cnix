# Heavily influenced by @tecosaur's https://github.com/tecosaur/golgi/blob/master/modules/auth/clients.nix
{
  config,
  lib,
  clib,
  self,
  ...
}: let
  services = config.cnix.server.services;

  readSecret = name: lib.trim (builtins.readFile (self + "/secrets/${name}OidcSecret.txt"));

  mkClient = {
    client_id,
    service,
    client_name ? client_id,
    redirect_paths ? [],
    redirect_uris ? [],
    require_pkce ? true,
    token_endpoint_auth_method ? "client_secret_basic",
    scopes ? [
      "openid"
      "email"
      "profile"
      "groups"
    ],
    response_types ? ["code"],
    extra ? {},
  }: let
    url = clib.server.mkFullDomain config service;
  in
    {
      inherit
        client_id
        client_name
        require_pkce
        token_endpoint_auth_method
        scopes
        response_types
        ;
      authorization_policy = client_id;
      client_secret = readSecret client_id;
      public = false;
      consent_mode = "implicit";
      pkce_challenge_method =
        if require_pkce
        then "S256"
        else "";
      grant_types = ["authorization_code"];
      userinfo_signed_response_alg = "none";
      redirect_uris =
        (map (p: "https://${url}/${p}") redirect_paths) ++ redirect_uris;
    }
    // extra;
  clientDefs = [
    {
      client_id = "immich";
      client_name = "Immich";
      service = services.immich;
      redirect_paths = [
        "auth/login"
        "user-settings"
      ];
      redirect_uris = ["app.immich:///oauth-callback"];
      require_pkce = false;
      token_endpoint_auth_method = "client_secret_post";
    }
    {
      client_id = "memos";
      client_name = "Memos";
      service = services.memos;
      redirect_paths = ["auth/callback"];
      require_pkce = false;
      token_endpoint_auth_method = "client_secret_post";
    }
    {
      client_id = "forgejo";
      client_name = "Forgejo";
      service = services.forgejo;
      redirect_paths = ["user/oauth2/authelia/callback"];
    }

    {
      client_id = "headscale";
      client_name = "Headscale";
      service = services.headscale;
      redirect_paths = [
        "oidc/callback"
        "admin/oidc/callback"
      ];
    }
    {
      client_id = "tailscale";
      client_name = "Tailscale";
      service = services.headscale;
      redirect_paths = [];
      redirect_uris = ["https://login.tailscale.com/a/oauth_response"];
      require_pkce = false;
      scopes = [
        "openid"
        "email"
        "profile"
      ];
    }
  ];

  # deny unless the user is in one of the service's groups.
  policyFor = def: {
    default_policy = "deny";
    rules = [
      {
        policy = "deny";
        subject = "group:lldap_strict_readonly";
      }
      {
        policy = "one_factor";
        subject = map (g: "group:${g}") def.service.groups;
      }
    ];
  };
in {
  services.authelia.instances.main.settings.identity_providers.oidc = {
    clients = map mkClient clientDefs;
    authorization_policies = lib.listToAttrs (
      map (def: lib.nameValuePair def.client_id (policyFor def)) clientDefs
    );
  };
}
