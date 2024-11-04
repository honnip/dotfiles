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
      user = lib.mkOption {
        type = lib.types.str;
        default = "hollo";
        description = "User under which Hollo runs";
      };
      group = lib.mkOption {
        type = lib.types.str;
        default = "hollo";
        description = "Group under which Hollo runs";
      };
      database = {
        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Create the database locally";
        };
        # For now, this depends on the pkg's patch
        # https://github.com/dahlia/hollo/issues/56
        host = lib.mkOption {
          type = lib.types.str;
          default = "/run/postgresql";
          description = "Database host address.";
        };
        port = lib.mkOption {
          type = lib.types.nullOr lib.types.port;
          default = null;
          description = "Database port.";
        };
        name = lib.mkOption {
          type = lib.types.str;
          default = "hollo";
          description = "Database name.";
        };
        user = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "hollo";
          description = "Database user.";
        };
        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/run/secrets/hollo-db-pw";
          description = "Database password.";
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
        port = lib.mkOption {
          type = lib.types.port;
          default = 3000;
          description = "The port number to listen on.";
        };
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
        allowPrivateAddress = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Setting this to true disables SSRF (Server-Side Request Forgery) protection.";
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
        User = cfg.user;
        Group = cfg.group;
        DynamicUser = true;

        LoadCredential = [
          "S3_ACCESS_KEY:${cfg.storage.secretAccessKeyFile}"
          "SECRET_KEY:${cfg.settings.secretKeyFile}"
        ] ++ (lib.optional (cfg.database.passwordFile != null "DB_PW:${cfg.database.passwordFile}"));

        # Capabilities
        CapabilityBoundingSet = "";
        # Proc FS
        ProcSubset = "pid";
        ProtectProc = "invisible";
        # Sandbox
        LockPersonality = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "full";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
        ];
        UMask = "0077";
      };

      script =
        ''
          export AWS_SECRET_ACCESS_KEY=$(< $CREDENTIALS_DIRECTORY/S3_ACCESS_KEY)
          export SECRET_KEY=$(< $CREDENTIALS_DIRECTORY/SECRET_KEY)
        ''
        + lib.optionalString (cfg.database.host != null) ''
          export DATABASE_HOST=${cfg.database.host}
        ''
        + lib.optionalString (cfg.database.port != null) ''
          export DATABASE_PORT=${cfg.database.port}
        ''
        + lib.optionalString (cfg.database.user != null) ''
          export DATABASE_USER=${cfg.database.user}
        ''
        + lib.optionalString (cfg.database.name != null) ''
          export DATABASE_NAME=${cfg.database.name}
        ''
        + lib.optionalString (cfg.database.passwordFile != null) ''
          export DATABASE_PASSWORD=$(< $CREDENTIALS_DIRECTORY/DB_PW)
        ''
        + ''
          ${lib.getExe cfg.package}
        '';

      environment = {
        PORT = cfg.settings.port;
        HOME_URL = cfg.settings.homeUrl;
        REMOTE_ACTOR_FETCH_POSTS = builtins.toString cfg.settings.remoteActorFetchPosts;
        LOG_LEVEL = cfg.settings.logLevel;
        LOG_QUERY = lib.boolToString cfg.settings.logQuery;
        BEHIND_PROXY = lib.boolToString cfg.settings.behindProxy;
        ALLOW_PRIVATE_ADDRESS = lib.boolToString cfg.settings.allowPrivateAddress;
        S3_REGION = cfg.storage.region;
        S3_BUCKET = cfg.storage.bucket;
        S3_URL_BASE = cfg.storage.urlBase;
        S3_ENDPOINT_URL = cfg.storage.endpointUrl;
        S3_FORCE_PATH_STYLE = lib.boolToString cfg.storage.forcePathStyle;
        AWS_ACCESS_KEY_ID = cfg.storage.accessKeyId;
        # Drizzle wants to make temp certs
        XDG_DATA_HOME = "/tmp";
      };
    };

    users.users = lib.mkIf (cfg.user == "hollo") {
      hollo = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "hollo") {
      hollo = { };
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
