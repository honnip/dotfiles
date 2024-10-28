{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.hollo;
in
{
  meta.maintainers = [ lib.maintainers.honnip ];

  options = {
    services.hollo = {
      enable = lib.mkEnableOption "hollo";
      package = lib.mkPackageOption pkgs "hollo" { };
      database = {
        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Create the database locally";
        };
        uri = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "postgresql:///hollo?host=/var/run/postgresql";
          description = "URI for PostgreSQL instance.";
          example = "postgresql://hollo@localhost:5432/hollo";
        };
        uriFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "URI for PostgreSQL instance.";
          example = "/run/secrets/hollo-db-uri";
        };
      };
      storage = {
        region = lib.mkOption {
          type = lib.types.str;
          default = "auto";
          description = "Region of the S3-compatible object storage.";
        };
        bucket = lib.mkOption {
          type = lib.types.str;
          description = "Bucket name of the S3-compatible object storage.";
        };
        urlBase = lib.mkOption {
          type = lib.types.str;
          description = "Public URL base of the S3-compatible object storage.";
        };
        endpointUrl = lib.mkOption {
          type = lib.types.str;
          description = "Endpoint URL for S3-compatible object storage.";
        };
        forcePathStyle = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to force path-style URLs for S3-compatible object storage.";
        };
        accessKeyId = lib.mkOption {
          type = lib.types.str;
          description = "Access key for S3-compatible object storage.";
        };
        secretAccessKeyFile = lib.mkOption {
          type = lib.types.path;
          description = "Secret key for S3-compatible object storage.";
        };
      };
      settings = {
        homeUrl = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "URL to which the homepage will redirect. If not set, the homepage will show the list of accounts on the instance.";
        };
        secretKeyFile = lib.mkOption {
          type = lib.types.path;
          description = "Secret key for securing the session";
        };
        remoteActorFetchPosts = lib.mkOption {
          type = lib.types.int;
          default = 10;
          description = "Number of recent public posts to fetch from remote actors when they are encountered first time.";
        };
        logLevel = lib.mkOption {
          type = lib.types.enum [
            "debug"
            "info"
            "warning"
            "error"
            "fatal"
          ];
          default = "info";
          description = "Log level for Hollo";
        };
        logQuery = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to log SQL queries.";
        };
        behindProxy = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether Hollo is behind a reverse proxy.";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.database.uri == null -> cfg.database.uriFile != null;
        message = "Must set one of `services.hollo.database.uri` and `services.hollo.database.uriFile`";
      }
      {
        assertion = cfg.database.uri != null -> cfg.database.uriFile == null;
        message = "Cannot set both `services.hollo.database.uri` and `services.hollo.database.uriFile`";
      }
    ];
    systemd.services.hollo = {
      after = [
        "network-online.target"
      ] ++ lib.optional cfg.database.createLocally "postgresql.service";

      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/hollo";
        DynamicUser = true;

        LoadCredential = [
          "S3_ACCESS_KEY:${cfg.storage.secretAccessKeyFile}"
          "SECRET_KEY:${cfg.settings.secretKeyFile}"
        ] ++ (lib.optional (cfg.database.uriFile != null) "DB_URI:${cfg.database.uriFile}");

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          # Required for connecting to database sockets,
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };

      preStart =
        ''
          export AWS_SECRET_ACCESS_KEY=$(< $CREDENTIALS_DIRECTORY/S3_ACCESS_KEY)
          export SECRET_KEY=$(< $CREDENTIALS_DIRECTORY/SECRET_KEY)
        ''
        + lib.optionalString (cfg.database.uri != null) ''
          export DATABASE_URL=${cfg.database.uri}
        ''
        + lib.optionalString (cfg.database.uriFile != null) ''
          export DATABASE_URL=$(< $CREDENTIALS_DIRECTORY/DB_URI)
        '';

      environment = {
        HOME_URL = cfg.settings.homeUrl;
        REMOTE_ACTOR_FETCH_POSTS = builtins.toString cfg.settings.remoteActorFetchPosts;
        LOG_LEVEL = cfg.settings.logLevel;
        LOG_QUERY = lib.boolToString cfg.settings.logQuery;
        BEHIND_PROXY = lib.boolToString cfg.settings.behindProxy;
        S3_REGION = cfg.storage.region;
        S3_BUCKET = cfg.storage.bucket;
        S3_URL_BASE = cfg.storage.urlBase;
        S3_ENDPOINT_URL = cfg.storage.endpointUrl;
        S3_FORCE_PATH_STYLE = lib.boolToString cfg.storage.forcePathStyle;
        AWS_ACCESS_KEY_ID = cfg.storage.accessKeyId;
      };
    };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = lib.mkDefault true;
      ensureDatabases = [ "hollo" ];
      ensureUsers = [
        {
          name = "hollo";
          ensureDBOwnership = true;
        }
      ];
    };
  };
}
