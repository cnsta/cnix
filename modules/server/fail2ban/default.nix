# from @notthebee
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.server.fail2ban;
in {
  options.server.fail2ban = {
    enable = lib.mkEnableOption {
      description = "Enable cloudflare fail2ban";
    };
    apiKeyFile = lib.mkOption {
      description = "File containing your API key, scoped to Firewall Rules: Edit";
      type = lib.types.str;
      example = lib.literalExpression ''
        Authorization: Bearer vH6-p0y=i4w3n7TjKqZ@x8D_lR!A9b2cOezXgUuJdE5F
        '''
      '';
    };
    zoneId = lib.mkOption {
      type = lib.types.str;
    };
    jails = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            serviceName = lib.mkOption {
              example = "vaultwarden";
              type = lib.types.str;
            };
            _groupsre = lib.mkOption {
              type = lib.types.lines;
              example = ''(?:(?:,?\s*"\w+":(?:"[^"]+"|\w+))*)'';
              default = "";
            };
            failRegex = lib.mkOption {
              type = lib.types.lines;
              example = ''
                ^Login failed from IP: <HOST>$
                ^Two-factor challenge failed from <HOST>$
              '';
            };
            ignoreRegex = lib.mkOption {
              type = lib.types.str;
              default = "";
            };
            datePattern = lib.mkOption {
              type = lib.types.str;
              default = "";
              example = '',?\s*"time"\s*:\s*"%%Y-%%m-%%d[T ]%%H:%%M:%%S(%%z)?"'';
              description = "Optional datepattern line for the fail2ban filter.";
            };
            maxRetry = lib.mkOption {
              type = lib.types.int;
              default = 3;
            };
          };
        }
      );
    };
  };
  config = lib.mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      extraPackages = [
        pkgs.curl
        pkgs.jq
      ];

      jails =
        lib.attrsets.mapAttrs (name: value: {
          settings = {
            bantime = "24h";
            findtime = "10m";
            enabled = true;
            backend = "systemd";
            journalmatch = "_SYSTEMD_UNIT=${value.serviceName}.service";
            port = "http,https";
            filter = "${name}";
            maxretry = 3;
            action = "cloudflare-token-agenix";
          };
        })
        cfg.jails;
    };

    environment.etc = lib.attrsets.mergeAttrsList [
      (lib.attrsets.mapAttrs' (
          name: value: (lib.nameValuePair "fail2ban/filter.d/${name}.conf" {
            text =
              ''
                [Definition]
                failregex = ${value.failRegex}
                ignoreregex = ${value.ignoreRegex}
              ''
              + lib.optionalString (value.datePattern != "") ''
                datepattern = ${value.datePattern}
              ''
              + lib.optionalString (value._groupsre != "") ''
                _groupsre = ${value._groupsre}
              '';
          })
        )
        cfg.jails)
      {
        "fail2ban/action.d/cloudflare-token-agenix.conf".text = let
          notes = "Fail2Ban on ${config.networking.hostName}";
          cfapi = "https://api.cloudflare.com/client/v4/zones/${cfg.zoneId}/firewall/access_rules/rules";
        in ''
          [Definition]
          actionstart =
          actionstop =
          actioncheck =
          actionunban = id=$(curl -s -X GET "${cfapi}" \
              -H @${cfg.apiKeyFile} -H "Content-Type: application/json" \
                  | jq -r '.result[] | select(.notes == "${notes}" and .configuration.target == "ip" and .configuration.value == "<ip>") | .id')
              if [ -z "$id" ]; then echo "id for <ip> cannot be found"; exit 0; fi; \
              curl -s -X DELETE "${cfapi}/$id" \
                  -H @${cfg.apiKeyFile} -H "Content-Type: application/json" \
                  --data '{"cascade": "none"}'
          actionban = curl -X POST "${cfapi}" -H @${cfg.apiKeyFile} -H "Content-Type: application/json" --data '{"mode":"block","configuration":{"target":"ip","value":"<ip>"},"notes":"${notes}"}'
          [Init]
          name = cloudflare-token-agenix
        '';
      }
    ];
  };
}
