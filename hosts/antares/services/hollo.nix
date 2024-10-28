{ config, ... }:
{
  services.hollo = {
    enable = true;
    storage = {
      bucket = "hollo";
      urlBase = "https://object.honnip.page";
      endpointUrl = "https://cfa56eee59e349d44849b0adb3c94c37.r2.cloudflarestorage.com";
      forcePathStyle = true;
      accessKeyId = "878f07c68eab3ec360af597f897f2cbf";
      secretAccessKeyFile = config.sops.secrets.hollo-s3-key.path;
    };
    settings = {
      secretKeyFile = config.sops.secrets.hollo-secret.path;
      behindProxy = true;
    };
  };

  services.cloudflared = {
    enable = true;
    tunnels."59e30a6e-ee6e-4047-8032-30365fa615bb" = {
      credentialsFile = config.sops.secrets.cf-tunnel.path;
      default = "http_status:404";
      ingress = {
        "c.honnip.page".service = "http://localhost:3000";
      };
    };
  };

  sops.secrets = {
    hollo-s3-key.sopsFile = ../secrets.yaml;
    hollo-secret.sopsFile = ../secrets.yaml;
    cf-tunnel = {
      format = "binary";
      sopsFile = ../cf-tunnel.json;
    };
  };
}
