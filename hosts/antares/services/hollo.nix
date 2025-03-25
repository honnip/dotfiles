{ config, pkgs, ... }:
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

  services.cloudflared =
    let
      patchedBuildGoModule = pkgs.buildGoModule.override {
        go = pkgs.buildPackages.go_1_22.overrideAttrs {
          pname = "cloudflare-go";
          version = "1.22.5-devel-cf";
          src = pkgs.fetchFromGitHub {
            owner = "cloudflare";
            repo = "go";
            rev = "af19da5605ca11f85776ef7af3384a02a315a52b";
            hash = "sha256-6VT9CxlHkja+mdO1DeFoOTq7gjb3T5jcf2uf9TB/CkU=";
          };
        };
      };
    in
    {
      enable = true;
      package = pkgs.cloudflared.override { buildGoModule = patchedBuildGoModule; };
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
      format = "binary";
      name = "tunnel-credentials.json";
      sopsFile = ../cf-tunnel.json;
    };
  };
}
