{
  config,
  lib,
  clib,
  self,
  pkgs,
  ...
}: let
  unit = "fluxer";
  srv = config.cnix.server;
  cfg = config.cnix.server.services.${unit};

  domain = clib.server.mkFullDomain config cfg;
  publicUrl = "https://${domain}";

  registry = "ghcr.io/fluxerapp";
  tag = "v1";
  img = name: "${registry}/fluxer-${name}:${tag}";

  network = "fluxer";
  dataDir = "/var/lib/fluxer";
  envFile = config.age.secrets.fluxerEnvironment.path;

  netOpts = alias: ["--network=${network}" "--network-alias=${alias}"];

  base = alias: {
    autoStart = true;
    extraOptions = netOpts alias;
    environmentFiles = [envFile];
  };

  commonEnv = {
    FLUXER_ENV = "production";
    NODE_ENV = "production";
    FLUXER_SELF_HOSTED = "true";
    FLUXER_BASE_DOMAIN = domain;
    FLUXER_PUBLIC_SCHEME = "https";
    FLUXER_PUBLIC_PORT = "443";
    FLUXER_TRUST_CLIENT_IP_HEADER = "true";
    FLUXER_CLIENT_IP_HEADER_NAME = "x-forwarded-for";

    FLUXER_DATABASE_BACKEND = "postgres";
    FLUXER_POSTGRES_HOST = "postgres";
    FLUXER_POSTGRES_PORT = "5432";
    FLUXER_POSTGRES_DATABASE = "fluxer";
    FLUXER_POSTGRES_USERNAME = "fluxer";
    FLUXER_POSTGRES_SSL = "false";

    FLUXER_KV_URL = "redis://valkey:6379/0";
    FLUXER_NATS_URL = "nats://nats:4222";
    FLUXER_NATS_JETSTREAM_URL = "nats://nats:4222";
    FLUXER_SVC_NATS_URL = "nats://nats:4222";
    FLUXER_SVC_SHARD_COUNT = "1";

    FLUXER_SEARCH_ENGINE = "meilisearch";
    FLUXER_SEARCH_URL = "http://meilisearch:7700";

    FLUXER_S3_ENDPOINT = "http://seaweedfs:8333";
    FLUXER_S3_PUBLIC_ENDPOINT = "http://seaweedfs:8333";
    FLUXER_S3_REGION = "us-east-1";
    FLUXER_S3_ACCESS_KEY_ID = "fluxer";
    FLUXER_S3_FORCE_PATH_STYLE = "true";
    FLUXER_S3_BUCKET_CDN = "fluxer";
    FLUXER_S3_BUCKET_UPLOADS = "fluxer-uploads";
    FLUXER_S3_BUCKET_DOWNLOADS = "fluxer-downloads";
    FLUXER_S3_BUCKET_REPORTS = "fluxer-reports";
    FLUXER_S3_BUCKET_HARVESTS = "fluxer-harvests";
    AWS_ACCESS_KEY_ID = "fluxer";
    AWS_DEFAULT_REGION = "us-east-1";
    AWS_EC2_METADATA_DISABLED = "true";

    FLUXER_LIVEKIT_ENABLED = "true";
    FLUXER_LIVEKIT_API_KEY = "fluxer";
    FLUXER_LIVEKIT_WEBHOOK_URL = "http://api:8080/webhooks/livekit";
    FLUXER_LIVEKIT_DEFAULT_REGION = ''{"id":"default","name":"Default","emoji":"🌍","latitude":0,"longitude":0}'';

    FLUXER_EMAIL_ENABLED = "false"; # flip on + add SMTP vars once mail is up
    FLUXER_EMAIL_PROVIDER = "none";
    FLUXER_EMAIL_FROM_EMAIL = "noreply@${domain}";
    FLUXER_EMAIL_FROM_NAME = "Fluxer";

    FLUXER_SMS_ENABLED = "false";
    FLUXER_CAPTCHA_ENABLED = "false";
    FLUXER_CAPTCHA_PROVIDER = "none";
    FLUXER_STRIPE_ENABLED = "false";
    FLUXER_NCMEC_ENABLED = "false";
    FLUXER_CLAMAV_ENABLED = "false";
    FLUXER_DISCOVERY_ENABLED = "true";

    FLUXER_VAPID_EMAIL = "admin@${domain}";

    FLUXER_INTERNAL_API_ENDPOINT = "http://api:8080";
    FLUXER_INTERNAL_GATEWAY_ENDPOINT = "http://gateway:8080";
    FLUXER_INTERNAL_MEDIA_PROXY_ENDPOINT = "http://media-proxy:8080";
    FLUXER_MARKETING_ENDPOINT = publicUrl;
    FLUXER_MEDIA_PROXY_ENDPOINT = "http://media-proxy:8080";
    FLUXER_MEDIA_ENDPOINT = "${publicUrl}/media";
    FLUXER_MEDIA_PROXY_UPLOAD_RELAY_ENDPOINT = "${publicUrl}/media";
  };

  gifsEnv = {
    FLUXER_SVC_NAME = "gifs";
    FLUXER_MEDIA_PROXY_PUBLIC_ENDPOINT = "${publicUrl}/media";
  };

  mkRouterShard = name: extraEnv: {
    "${unit}-${name}" =
      base name
      // {
        image = img name;
        environment = commonEnv // extraEnv // {FLUXER_SVC_MODE = "router";};
        dependsOn = ["${unit}-nats"];
      };
    "${unit}-${name}-shard" =
      base "${name}-shard"
      // {
        image = img name;
        environment =
          commonEnv
          // extraEnv
          // {
            FLUXER_SVC_MODE = "shard";
            FLUXER_SVC_SHARD_ID = "0";
          };
        dependsOn = ["${unit}-nats"];
      };
  };

  caddyfile = pkgs.writeText "fluxer-Caddyfile" ''
    {
    	servers {
    		trusted_proxies static private_ranges
    	}
    }

    :80 {
    	encode zstd gzip

    	handle_path /api/* {
    		reverse_proxy api:8080
    	}

    	handle /gateway {
    		rewrite * /
    		reverse_proxy gateway:8080
    	}

    	handle_path /gateway/* {
    		reverse_proxy gateway:8080
    	}

    	handle_path /media/* {
    		reverse_proxy media-proxy:8080
    	}

    	# Not in upstream's Caddyfile, deliberately added: the desktop client
    	# validates an instance by fetching /.well-known/fluxer at the origin
    	# root, which otherwise falls through to the SPA and fails with
    	# "Not a valid Fluxer instance". The api serves the document at this
    	# exact path (same one app-proxy's discovery cache consumes).
    	handle /.well-known/fluxer {
    		reverse_proxy api:8080
    	}

    	handle_path /livekit/* {
    		reverse_proxy host.containers.internal:7880
    	}

    	handle /admin {
    		rewrite * /
    		reverse_proxy admin:8080
    	}

    	handle_path /admin/* {
    		reverse_proxy admin:8080
    	}

    	@staticAssets path /fonts/* /web/* /emoji/* /libs/* /avatars/* /badges/* /desktop/* /embeds/*
    	handle @staticAssets {
    		reverse_proxy static-proxy:8080
    	}

    	handle {
    		reverse_proxy app-proxy:8080
    	}
    }

    :8088 {
    	handle_path /api/* {
    		reverse_proxy api:8080
    	}
    }
  '';

  livekitConfig = pkgs.writeText "fluxer-livekit.yaml" ''
    port: 7880
    log_level: info

    rtc:
      tcp_port: 7881
      udp_port: 7882
      use_external_ip: false

    webhook:
      api_key: fluxer
      urls:
        - http://127.0.0.1:${toString cfg.port}/api/webhooks/livekit
  '';
in {
  config = lib.mkIf (srv.infra.podman.enable && cfg.enable) {
    age.secrets = {
      fluxerEnvironment = {
        file = self + "/secrets/fluxerEnvironment.age";
        mode = "0444";
      };
    };

    networking.firewall = {
      interfaces."tailscale0" = {
        allowedTCPPorts = [7881];
        allowedUDPPorts = [7882];
      };
      interfaces."fluxer0" = {
        allowedTCPPorts = [7880 5533];
        allowedUDPPorts = [5533];
      };
    };

    systemd.tmpfiles.rules = [
      "d ${dataDir} 0750 root root -"
      "d ${dataDir}/postgres 0750 root root -"
      "d ${dataDir}/nats 0750 root root -"
      "d ${dataDir}/meilisearch 0750 root root -"
      "d ${dataDir}/seaweedfs 0750 root root -"
      "d ${dataDir}/caddy-data 0750 root root -"
      "d ${dataDir}/caddy-config 0750 root root -"
    ];

    systemd.services = lib.mkMerge [
      {
        "init-${unit}-network" = {
          description = "Create the ${unit} podman network";
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          script = ''
            ${pkgs.podman}/bin/podman network exists ${network} \
              || ${pkgs.podman}/bin/podman network create --interface-name fluxer0 ${network}
          '';
        };

        "${unit}-seaweedfs-init" = {
          description = "Create Fluxer SeaweedFS buckets";
          after = ["podman-${unit}-seaweedfs.service"];
          requires = ["podman-${unit}-seaweedfs.service"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          script = ''
            weedshell() {
              ${pkgs.podman}/bin/podman exec -i ${unit}-seaweedfs \
                weed shell -master=localhost:9333
            }

            ok=0
            for i in $(seq 1 90); do
              for b in fluxer fluxer-uploads fluxer-downloads fluxer-reports fluxer-harvests; do
                echo "s3.bucket.create -name $b" | weedshell >/dev/null 2>&1 || true
              done
              if echo "s3.bucket.list" | weedshell 2>/dev/null | grep -q "fluxer-harvests"; then
                ok=1
                break
              fi
              sleep 2
            done
            if [ "$ok" != 1 ]; then
              echo "SeaweedFS bucket creation failed; s3.bucket.list output:" >&2
              echo "s3.bucket.list" | weedshell >&2 || true
              exit 1
            fi
            echo "buckets ready"
          '';
        };
      }

      (lib.genAttrs
        (map (n: "podman-${unit}-${n}") [
          "caddy"
          "postgres"
          "valkey"
          "nats"
          "meilisearch"
          "seaweedfs"
          "api"
          "worker"
          "gateway"
          "media-proxy"
          "static-proxy"
          "app-proxy"
          "admin"
          "snowflakes"
          "snowflakes-shard"
          "users"
          "users-shard"
          "gifs"
          "gifs-shard"
          "messages"
          "messages-shard"
          "unfurl"
          "unfurl-shard"
        ])
        (_: {
          after = ["init-${unit}-network.service"];
          requires = ["init-${unit}-network.service"];
        }))
      {
        "podman-${unit}-api" = {
          after = ["${unit}-seaweedfs-init.service"];
          wants = ["${unit}-seaweedfs-init.service"];
        };
        "podman-${unit}-worker" = {
          after = ["${unit}-seaweedfs-init.service"];
          wants = ["${unit}-seaweedfs-init.service"];
        };
        "podman-${unit}-media-proxy" = {
          after = ["${unit}-seaweedfs-init.service"];
          wants = ["${unit}-seaweedfs-init.service"];
        };
        "podman-${unit}-app-proxy" = {
          preStart = ''
            for i in $(seq 1 150); do
              ${pkgs.curl}/bin/curl -fsS -o /dev/null \
                "http://127.0.0.1:${toString cfg.port}/api/.well-known/fluxer" \
                && exit 0
              sleep 2
            done
            echo "api discovery endpoint never became ready" >&2
            exit 1
          '';
        };
      }
    ];

    virtualisation.oci-containers.containers = lib.mkMerge [
      {
        "${unit}-caddy" =
          base "caddy"
          // {
            image = "caddy:2.10-alpine";
            ports = ["127.0.0.1:${toString cfg.port}:80"];
            environment.FLUXER_CADDY_SITE_ADDRESS = ":80";
            volumes = [
              "${caddyfile}:/etc/caddy/Caddyfile:ro"
              "${dataDir}/caddy-data:/data"
              "${dataDir}/caddy-config:/config"
            ];
            dependsOn = [
              "${unit}-api"
              "${unit}-gateway"
              "${unit}-media-proxy"
              "${unit}-static-proxy"
              "${unit}-admin"
            ];
          };

        "${unit}-postgres" =
          base "postgres"
          // {
            image = "postgres:16-alpine";
            environment = {
              POSTGRES_DB = "fluxer";
              POSTGRES_USER = "fluxer";
            };
            volumes = ["${dataDir}/postgres:/var/lib/postgresql/data"];
          };

        "${unit}-valkey" =
          base "valkey"
          // {
            image = "valkey/valkey:8.1-alpine";
            cmd = ["valkey-server" "--save" "" "--appendonly" "no"];
          };

        "${unit}-nats" =
          base "nats"
          // {
            image = "nats:2.14-alpine";
            cmd = ["-js" "-sd" "/data" "-m" "8222"];
            volumes = ["${dataDir}/nats:/data"];
          };

        "${unit}-meilisearch" =
          base "meilisearch"
          // {
            image = "getmeili/meilisearch:v1.12";
            environment = {
              MEILI_ENV = "production";
              MEILI_NO_ANALYTICS = "true";
            };
            volumes = ["${dataDir}/meilisearch:/meili_data"];
          };

        "${unit}-seaweedfs" =
          base "seaweedfs"
          // {
            image = "chrislusf/seaweedfs:4.34";
            cmd = ["server" "-s3" "-dir=/data"];
            volumes = ["${dataDir}/seaweedfs:/data"];
          };

        "${unit}-livekit" = {
          autoStart = true;
          image = "livekit/livekit-server:v1.12.0";
          cmd = ["--config" "/etc/livekit.yaml"];
          environmentFiles = [envFile];
          volumes = ["${livekitConfig}:/etc/livekit.yaml:ro"];
          extraOptions = ["--network=host"];
        };

        "${unit}-api" =
          base "api"
          // {
            image = img "api";
            environment =
              commonEnv
              // {
                FLUXER_API_PORT = "8080";
                FLUXER_API_PRESIGNED_ATTACHMENT_UPLOADS_ENABLED = "true";
              };
            dependsOn = [
              "${unit}-postgres"
              "${unit}-valkey"
              "${unit}-nats"
              "${unit}-meilisearch"
              "${unit}-seaweedfs"
              "${unit}-gifs"
              "${unit}-gifs-shard"
              "${unit}-snowflakes"
              "${unit}-snowflakes-shard"
              "${unit}-messages"
              "${unit}-messages-shard"
              "${unit}-users"
              "${unit}-users-shard"
            ];
          };

        "${unit}-worker" =
          base "worker"
          // {
            image = img "api";
            workdir = "/usr/src/app/fluxer_api";
            cmd = ["./node_modules/.bin/tsx" "src/WorkerEntrypoint.ts"];
            environment =
              commonEnv
              // {
                FLUXER_API_WORKER_MODE = "all_lanes";
                FLUXER_API_WORKER_ENABLE_CRON_SCHEDULER = "true";
                FLUXER_API_WORKER_ENABLE_VOICE_RECONCILIATION = "true";
              };
            dependsOn = [
              "${unit}-postgres"
              "${unit}-valkey"
              "${unit}-nats"
              "${unit}-seaweedfs"
              "${unit}-snowflakes-shard"
              "${unit}-messages-shard"
              "${unit}-users-shard"
            ];
          };

        "${unit}-gateway" =
          base "gateway"
          // {
            image = img "gateway";
            environment =
              commonEnv
              // {
                FLUXER_GATEWAY_PORT = "8080";
                FLUXER_GATEWAY_MEDIA_PROXY_ENDPOINT = "${publicUrl}/media";
                FLUXER_GATEWAY_STATIC_CDN_ENDPOINT = publicUrl;
                FLUXER_GATEWAY_LOGGER_LEVEL = "info";
              };
            dependsOn = ["${unit}-nats" "${unit}-valkey"];
          };

        "${unit}-media-proxy" =
          base "media-proxy"
          // {
            image = img "media-proxy";
            environment =
              commonEnv
              // {
                FLUXER_MEDIA_PROXY_HOST = "0.0.0.0";
                FLUXER_MEDIA_PROXY_PORT = "8080";
                FLUXER_MEDIA_PROXY_MODE = "upload";
                FLUXER_MEDIA_PROXY_STORAGE_BACKEND = "s3";
              };
            dependsOn = ["${unit}-seaweedfs" "${unit}-nats"];
          };

        "${unit}-static-proxy" =
          base "static-proxy"
          // {
            image = img "static";
          };

        "${unit}-app-proxy" =
          base "app-proxy"
          // {
            image = img "app-proxy-self-hosted";
            environment = {
              FLUXER_APP_PROXY_HOST = "0.0.0.0";
              FLUXER_APP_PROXY_PORT = "8080";
              DISCOVERY_UPSTREAM_URL = "http://caddy:8088/api/.well-known/fluxer";
              PUBLIC_BOOTSTRAP_API_ENDPOINT = "/api";
              PUBLIC_BOOTSTRAP_API_PUBLIC_ENDPOINT = "${publicUrl}/api";
            };
            dependsOn = ["${unit}-api" "${unit}-caddy"];
          };

        "${unit}-admin" =
          base "admin"
          // {
            image = img "admin";
            environment =
              commonEnv
              // {
                FLUXER_ADMIN_HOST = "0.0.0.0";
                FLUXER_ADMIN_PORT = "8080";
                FLUXER_ADMIN_BASE_PATH = "/admin";
                FLUXER_API_ENDPOINT = "http://api:8080";
                FLUXER_ADMIN_ENDPOINT = "${publicUrl}/admin";
                FLUXER_APP_ENDPOINT = publicUrl;
                FLUXER_MEDIA_ENDPOINT = "${publicUrl}/media";
                FLUXER_STATIC_CDN_ENDPOINT = publicUrl;
                FLUXER_ADMIN_OAUTH_REDIRECT_URI = "${publicUrl}/admin/oauth2_callback";
              };
            dependsOn = ["${unit}-api"];
          };
      }

      (mkRouterShard "snowflakes" {})
      (mkRouterShard "users" {})
      (mkRouterShard "messages" {})
      (mkRouterShard "unfurl" {})
      (mkRouterShard "gifs" gifsEnv)
    ];
  };
}
