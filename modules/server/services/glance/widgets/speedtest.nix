{lib, ...}: let
  enable = true;

  auth = {
    "Authorization" = "Bearer \${SPEEDTEST_TRACKER_API_TOKEN}";
    "Accept" = "application/json";
  };
in
  lib.optional enable {
    type = "custom-api";
    title = "Internet Speed";
    cache = "1h";
    "title-url" = "\${SPEEDTEST_URL}";
    url = "\${SPEEDTEST_URL}/api/v1/results/latest";
    headers = auth;
    subrequests.stats = {
      url = "\${SPEEDTEST_URL}/api/v1/stats";
      headers = auth;
    };
    options.showPercentageDiff = true;
    template = builtins.readFile ./templates/speedtest.html;
  }
