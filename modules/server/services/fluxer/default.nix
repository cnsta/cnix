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

  mail = "fluxer@cnst.dev";

  netOpts = alias: ["--network=${network}" "--network-alias=${alias}"];

  plain = alias: {
    autoStart = true;
    extraOptions = netOpts alias;
  };
  base = alias: plain alias // {environmentFiles = [envFile];};

  mediaPolicy = "report";

  commonEnv = {
    FLUXER_ENV = "production";
    FLUXER_SELF_HOSTED = "true";
    FLUXER_BASE_DOMAIN = domain;
    FLUXER_PUBLIC_SCHEME = "https";
    FLUXER_PUBLIC_PORT = "443";
    FLUXER_TRUST_CLIENT_IP_HEADER = "true";
    FLUXER_BREACHED_PASSWORD_CHECK_ENABLED = "true";

    FLUXER_APP_ENDPOINT = publicUrl;
    FLUXER_MEDIA_ENDPOINT = "${publicUrl}/media";
    FLUXER_MEDIA_PROXY_PUBLIC_ENDPOINT = "${publicUrl}/media";
    FLUXER_ADMIN_ENDPOINT = "${publicUrl}/admin";
    FLUXER_MARKETING_ENDPOINT = publicUrl;

    FLUXER_DATABASE_BACKEND = "postgres";
    FLUXER_POSTGRES_HOST = "postgres";
    FLUXER_POSTGRES_DATABASE = "fluxer";
    FLUXER_POSTGRES_USERNAME = "fluxer";

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
    FLUXER_S3_BUCKET_REPORTS = "fluxer-reports";
    FLUXER_S3_BUCKET_HARVESTS = "fluxer-harvests";
    FLUXER_API_PRESIGNED_HARVEST_DOWNLOADS_ENABLED = "false";

    FLUXER_LIVEKIT_ENABLED = "true";
    FLUXER_LIVEKIT_API_KEY = "fluxer";
    FLUXER_LIVEKIT_INTERNAL_URL = "http://host.containers.internal:7880";
    FLUXER_LIVEKIT_URL = "wss://${domain}/livekit";
    FLUXER_LIVEKIT_DEFAULT_REGION = ''{"id":"default","name":"Default","emoji":"🌍","latitude":0,"longitude":0}'';

    FLUXER_ACCOUNT_IDENTITY = "email";
    FLUXER_TAG_STYLE = "none";

    FLUXER_EMAIL_ENABLED = "true";
    FLUXER_EMAIL_PROVIDER = "smtp";
    FLUXER_EMAIL_FROM_EMAIL = mail;
    FLUXER_EMAIL_SMTP_HOST = "smtp.protonmail.ch";
    FLUXER_EMAIL_SMTP_PORT = "587";
    FLUXER_EMAIL_SMTP_USERNAME = mail;
    FLUXER_EMAIL_SMTP_TLS_MODE = "starttls";

    FLUXER_VAPID_EMAIL = "admin@${domain}";
    FLUXER_PASSKEY_RP_ID = domain;
    FLUXER_PASSKEY_ADDITIONAL_ALLOWED_ORIGINS = publicUrl;

    FLUXER_INTERNAL_API_ENDPOINT = "http://api:8080";
    FLUXER_INTERNAL_MEDIA_PROXY_ENDPOINT = "http://media-proxy:8080";
    FLUXER_MEDIA_PROXY_UPLOAD_RELAY_ENDPOINT = "${publicUrl}/media";
  };

  nodeEnv = {
    NODE_OPTIONS = "--enable-source-maps";
    NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-certificates.crt";
    FLUXER_POSTGRES_MAX_CONNECTIONS = "25";
  };

  mkRouterShard = name: shardEnv: {
    "${unit}-${name}" =
      base name
      // {
        image = img name;
        environment =
          commonEnv
          // {
            FLUXER_SVC_NAME = name;
            FLUXER_SVC_MODE = "router";
          };
        dependsOn = ["${unit}-nats"];
      };
    "${unit}-${name}-shard" =
      base "${name}-shard"
      // {
        image = img name;
        environment =
          commonEnv
          // shardEnv
          // {
            FLUXER_SVC_NAME = name;
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
    		trusted_proxies_strict
    	}
    }

    :8080 {
    	encode zstd gzip

    	handle /_health {
    		respond "OK" 200
    	}

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

    	# LiveKit runs on the host network.
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

    	@staticAssets path /web/* /emoji/* /libs/* /avatars/* /badges/* /desktop/*
    	handle @staticAssets {
    		reverse_proxy static-proxy:8080
    	}

    	handle /.well-known/fluxer {
    		reverse_proxy api:8080
    	}

    	handle {
    		reverse_proxy app-proxy:8080
    	}
    }

    :8088 {
    	handle /.well-known/fluxer {
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
      use_external_ip: true

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
        mode = "0400";
      };
    };

    services.traefik.dynamicConfigOptions.http.routers."${unit}-admin" = lib.mkIf srv.infra.traefik.enable {
      entryPoints = ["websecure"];
      rule = "Host(`${domain}`) && (Path(`/admin`) || PathPrefix(`/admin/`))";
      service = unit;
      middlewares = ["security-headers" "private"];
      tls = {};
    };

    networking.firewall = {
      allowedTCPPorts = [7881];
      allowedUDPPorts = [7882];
      interfaces."fluxer0" = {
        allowedTCPPorts = [7880 5533];
        allowedUDPPorts = [5533];
      };
    };

    systemd.tmpfiles.rules = [
      "d ${dataDir} 0750 root root -"
      "d ${dataDir}/postgres 0750 root root -"
      "d ${dataDir}/valkey 0750 root root -"
      "d ${dataDir}/nats 0750 root root -"
      "d ${dataDir}/meilisearch 0750 root root -"
      "d ${dataDir}/seaweedfs 0750 root root -"
      "d ${dataDir}/edge-data 0750 root root -"
      "d ${dataDir}/edge-config 0750 root root -"
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
          description = "Create Fluxer SeaweedFS buckets and S3 identity";
          after = ["podman-${unit}-seaweedfs.service"];
          requires = ["podman-${unit}-seaweedfs.service"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            EnvironmentFile = envFile;
          };
          script = ''
            weedshell() {
              ${pkgs.podman}/bin/podman exec -i ${unit}-seaweedfs \
                weed shell -master=localhost:9333
            }

            buckets="fluxer fluxer-uploads fluxer-reports fluxer-harvests"
            for i in $(seq 1 90); do
              listed=$(echo "s3.bucket.list" | weedshell 2>/dev/null || true)
              missing=""
              for b in $buckets; do
                echo "$listed" | grep -q "^[[:space:]]*$b[[:space:]]" || missing="$missing $b"
              done
              if [ -z "$missing" ]; then
                echo "s3.configure -user=fluxer -access_key=fluxer -secret_key=$FLUXER_S3_SECRET_ACCESS_KEY -actions=Admin,Read,Write,List,Tagging -apply" \
                  | weedshell >/dev/null
                echo "buckets ready"
                exit 0
              fi
              for b in $missing; do
                echo "s3.bucket.create -name $b" | weedshell >/dev/null 2>&1 || true
              done
              sleep 2
            done
            echo "SeaweedFS bucket creation failed; missing:$missing" >&2
            exit 1
          '';
        };
      }

      (lib.genAttrs
        (map (n: "podman-${unit}-${n}") [
          "edge"
          "postgres"
          "valkey"
          "nats"
          "meilisearch"
          "seaweedfs"
          "api"
          "worker"
          "gateway"
          "media-proxy"
          "push"
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
      (lib.genAttrs
        (map (n: "podman-${unit}-${n}") ["api" "worker" "media-proxy"])
        (_: {
          after = ["${unit}-seaweedfs-init.service"];
          wants = ["${unit}-seaweedfs-init.service"];
        }))
      {
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
        "${unit}-edge" =
          plain "edge"
          // {
            image = "docker.io/library/caddy:2.11-alpine";
            ports = ["127.0.0.1:${toString cfg.port}:8080"];
            volumes = [
              "${caddyfile}:/etc/caddy/Caddyfile:ro"
              "${dataDir}/edge-data:/data"
              "${dataDir}/edge-config:/config"
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
            image = "docker.io/library/postgres:16-alpine";
            extraOptions = netOpts "postgres" ++ ["--shm-size=1g"];
            cmd = lib.concatMap (s: ["-c" s]) [
              "max_connections=150"
              "shared_buffers=512MB"
              "effective_cache_size=2GB"
              "work_mem=8MB"
              "maintenance_work_mem=256MB"
              "autovacuum_work_mem=128MB"
              "random_page_cost=1.1"
              "effective_io_concurrency=200"
              "default_statistics_target=200"
              "jit=off"
              "min_wal_size=512MB"
              "max_wal_size=2GB"
              "checkpoint_completion_target=0.9"
              "wal_buffers=16MB"
              "wal_compression=zstd"
              "bgwriter_delay=50ms"
              "bgwriter_lru_maxpages=1000"
              "autovacuum_vacuum_scale_factor=0.05"
              "autovacuum_analyze_scale_factor=0.02"
              "autovacuum_vacuum_cost_limit=2000"
              "track_io_timing=on"
              "shared_preload_libraries=pg_stat_statements"
            ];
            environment = {
              POSTGRES_DB = "fluxer";
              POSTGRES_USER = "fluxer";
            };
            volumes = ["${dataDir}/postgres:/var/lib/postgresql/data"];
          };

        "${unit}-valkey" =
          plain "valkey"
          // {
            image = "docker.io/valkey/valkey:9.1-alpine";
            cmd = [
              "valkey-server"
              "--appendonly"
              "yes"
              "--appendfsync"
              "everysec"
              "--dir"
              "/data"
              "--maxmemory"
              "192mb"
              "--maxmemory-policy"
              "noeviction"
            ];
            volumes = ["${dataDir}/valkey:/data"];
          };

        "${unit}-nats" =
          plain "nats"
          // {
            image = "docker.io/library/nats:2.14-alpine";
            cmd = ["-js" "-sd" "/data" "-m" "8222"];
            volumes = ["${dataDir}/nats:/data"];
          };

        "${unit}-meilisearch" =
          base "meilisearch"
          // {
            image = "docker.io/getmeili/meilisearch:v1.53";
            environment = {
              MEILI_ENV = "production";
              MEILI_NO_ANALYTICS = "true";
              MEILI_UPGRADE_DB = "true";
              MEILI_MAX_INDEXING_MEMORY = "256mb";
              MEILI_MAX_INDEXING_THREADS = "2";
            };
            volumes = ["${dataDir}/meilisearch:/meili_data"];
          };

        "${unit}-seaweedfs" =
          plain "seaweedfs"
          // {
            image = "docker.io/chrislusf/seaweedfs:4.47";
            cmd = ["server" "-s3" "-dir=/data" "-master.telemetry=false"];
            environment = {
              GOMEMLIMIT = "1536MiB";
              WEED_MASTER_VOLUME_GROWTH_COPY_1 = "1";
            };
            volumes = ["${dataDir}/seaweedfs:/data"];
          };

        "${unit}-livekit" = {
          autoStart = true;
          image = "docker.io/livekit/livekit-server:v1.12.0";
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
              // nodeEnv
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
            cmd = ["node" "dist/WorkerEntrypoint.js"];
            environment =
              commonEnv
              // nodeEnv
              // {
                FLUXER_API_WORKER_MODE = "all_lanes";
                FLUXER_API_WORKER_ENABLE_CRON_SCHEDULER = "true";
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
              };
            dependsOn = ["${unit}-nats" "${unit}-valkey"];
          };

        "${unit}-media-proxy" =
          base "media-proxy"
          // {
            image = img "media-proxy";
            extraOptions =
              netOpts "media-proxy"
              ++ [
                "--health-cmd=bash -c 'for i in 1 2 3 4 5 6 7 8 9 10; do (exec 3<>/dev/tcp/127.0.0.1/8080 && printf \"GET /_health HTTP/1.0\\r\\n\\r\\n\" >&3 && grep -q 200 <&3) 2>/dev/null && exit 0; sleep 1; done; exit 1'"
                "--health-interval=30s"
                "--health-retries=3"
                "--health-timeout=15s"
              ];
            environment =
              commonEnv
              // {
                FLUXER_MEDIA_PROXY_PORT = "8080";
                FLUXER_MEDIA_PROXY_MODE = "upload";
                FLUXER_MEDIA_PROXY_STORAGE_BACKEND = "s3";
                FLUXER_MEDIA_PROXY_ATTACHMENT_SIGNATURE_MODE = mediaPolicy;
                FLUXER_MEDIA_PROXY_CORS_MODE = mediaPolicy;
                FLUXER_MEDIA_PROXY_CORS_ALLOWED_ORIGINS = publicUrl;
                # seaweedfs-init installs an S3 identity, so anonymous reads fail.
                FLUXER_S3_READ_SIGNED = "true";
              };
            dependsOn = ["${unit}-seaweedfs" "${unit}-nats"];
          };

        "${unit}-push" =
          base "push"
          // {
            image = img "push";
            environment = commonEnv;
            dependsOn = ["${unit}-nats" "${unit}-api"];
          };

        "${unit}-static-proxy" =
          plain "static-proxy"
          // {
            image = img "static";
          };

        "${unit}-app-proxy" =
          plain "app-proxy"
          // {
            image = img "app-proxy-self-hosted";
            extraOptions =
              netOpts "app-proxy"
              ++ [
                "--health-cmd=sh -c 'for i in 1 2 3 4 5 6 7 8 9 10; do curl -sf http://localhost:8080/_health && exit 0; sleep 1; done; exit 1'"
                "--health-interval=30s"
                "--health-retries=3"
                "--health-timeout=15s"
              ];
            environment = {
              FLUXER_APP_PROXY_PORT = "8080";
              FLUXER_S3_BUCKET_UPLOADS = "fluxer-uploads";
              FLUXER_MEDIA_ENDPOINT = "${publicUrl}/media";
              FLUXER_STATIC_CDN_ENDPOINT = publicUrl;
              # The :8088 edge listener sets the client-IP header the API requires.
              DISCOVERY_UPSTREAM_URL = "http://edge:8088/.well-known/fluxer";
            };
            dependsOn = ["${unit}-api" "${unit}-edge"];
          };

        "${unit}-admin" =
          base "admin"
          // {
            image = img "admin";
            environment =
              commonEnv
              // {
                FLUXER_ADMIN_PORT = "8080";
                FLUXER_ADMIN_BASE_PATH = "/admin";
                FLUXER_API_ENDPOINT = "http://api:8080";
                FLUXER_STATIC_CDN_ENDPOINT = publicUrl;
              };
            dependsOn = ["${unit}-api"];
          };
      }

      (mkRouterShard "snowflakes" {})
      (mkRouterShard "users" {FLUXER_POSTGRES_MAX_CONNECTIONS = "20";})
      (mkRouterShard "messages" {FLUXER_POSTGRES_MAX_CONNECTIONS = "20";})
      (mkRouterShard "unfurl" {FLUXER_MEDIA_PROXY_ENDPOINT = "http://media-proxy:8080";})
      (mkRouterShard "gifs" {})
    ];
  };
}
