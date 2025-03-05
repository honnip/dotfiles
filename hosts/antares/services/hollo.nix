{ config, ... }:
{
  services.hollo = {
    enable = true;
    storage = {
      type = "s3";
      bucket = "hollo";
      urlBase = "https://object.honnip.page";
      endpointUrl = "https://cfa56eee59e349d44849b0adb3c94c37.r2.cloudflarestorage.com";
      forcePathStyle = true;
      accessKeyId = "878f07c68eab3ec360af597f897f2cbf";
      secretAccessKeyFile = config.sops.secrets.hollo-s3-key.path;
    };
    settings = {
      logLevel = "debug";
      behindProxy = true;
      secretKeyFile = config.sops.secrets.hollo-secret.path;
      TZ = "Asia/Seoul";
      remoteActorFetchPosts = 35;
    };
  };

  services.cloudflared = {
    enable = true;
    user = "honnip";
    tunnels."4ef10520-5add-40a4-91ea-92706b3cf908" = {
      credentialsFile = config.sops.secrets.cf-tunnel.path;
      default = "http_status:404";
      ingress = {
        "c.honnip.page" = {
          service = "http://localhost:3000";
        };
      };
    };
  };

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 7500000;
    "net.core.wmem_max" = 7500000;
  };

  sops.secrets = {
    hollo-s3-key.sopsFile = ../secrets.yaml;
    hollo-secret.sopsFile = ../secrets.yaml;
    cf-tunnel = {
      owner = "honnip";
      format = "binary";
      name = "tunnel-credentials.json";
      sopsFile = ../cf-tunnel.json;
    };
  };
}
