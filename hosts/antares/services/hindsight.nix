{ config, pkgs, ... }: {
  users.users.hindsight = {
    isSystemUser = true;
    group = "hindsight";
    home = "/var/lib/hindsight";
    createHome = true;
    linger = true;
    autoSubUidGidRange = true;
  };
  users.groups.hindsight = { };

  virtualisation.oci-containers.containers.hindsight = {
    image = "hindsight:latest";
    imageFile = pkgs.dockerTools.pullImage {
      imageName = "ghcr.io/vectorize-io/hindsight";
      imageDigest = "sha256:ba349b5bc2d8af4dd9acaa59f3c04f224c4652a0d9409e42026f8e5282842061";
      hash = "sha256-7DF7fHVsbpX2delRcEvmakGEy+PG1vhl/YnahNo+H2k=";
      finalImageName = "hindsight";
      finalImageTag = "latest";
    };
    autoStart = true;
    pull = "never";
    ports = [
      "127.0.0.1:8888:8888"
      "127.0.0.1:9999:9999"
    ];
    volumes = [
      "hindsight-models:/home/hindsight/.cache"
      "/run/postgresql:/run/postgresql"
    ];
    environmentFiles = [
      config.sops.secrets.hindsight.path
    ];
    environment = {
      HINDSIGHT_API_DATABASE_URL = "postgresql://hindsight@/hindsight?host=/run/postgresql";
      HINDSIGHT_API_VECTOR_EXTENSION = "pgvector";
      HINDSIGHT_API_TEXT_SEARCH_EXTENSION = "pgroonga";

      HINDSIGHT_API_LLM_PROVIDER = "openrouter";
      HINDSIGHT_API_LLM_MODEL = "deepseek/deepseek-v4.1-flash";
      HINDSIGHT_API_LLM_BASE_URL = "https://openrouter.ai/api/v1";
      HINDSIGHT_API_WORKER_ID = "hindsight";
      HINDSIGHT_API_RERANKER_LOCAL_MODEL = "BAAI/bge-reranker-v2-m3";

      HINDSIGHT_API_LOG_LEVEL = "info";
    };

    extraOptions = [
      "--userns=keep-id:uid=1000,gid=1000"
      "--shm-size=1g"
      "--memory=4g"
    ];

    podman.user = "hindsight";
  };

  systemd.services.podman-hindsight = {
    after = [
      "postgresql.service"
      "hindsight-db-bootstrap.service"
    ];
  };

  systemd.services.hindsight-db-bootstrap = {
    description = "Hindsight Database bootstrap";
    after = [ "postgresql.service" ];
    requires = [ "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.postgresql ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "postgres";
    };
    script = ''
      set -euo pipefail
      psql -v -d hindsight -c 'CREATE EXTENSION IF NOT EXISTS vector CASCADE;'
      psql -v -d hindsight -c 'CREATE EXTENSION IF NOT EXISTS pgroonga CASCADE;'
    '';
  };

  services.postgresql = {
    enable = true;
    extensions = ps: [
      ps.pgvector
      ps.pgroonga
    ];
    ensureDatabases = [ "hindsight" ];
    ensureUsers = [
      {
        name = "hindsight";
        ensureDBOwnership = true;
      }
    ];
  };

  sops.secrets.hindsight = {
    sopsFile = ../secrets.yaml;
    restartUnits = [ "podman-hindsight.service" ];
    mode = "0440";
    owner = "hindsight";
    group = "hindsight";
  };
}
