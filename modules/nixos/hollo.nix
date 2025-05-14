self:
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
  options = {
    services.hollo = {
      enable = lib.mkEnableOption "hollo";
      package = lib.mkOption {
        type = lib.types.package;
        default = self.packages.${pkgs.system}.hollo;
        description = "Package to use for hollo";
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
          default = 5432;
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
        type = lib.mkOption {
          type = lib.types.enum [
            "s3"
            "fs"
          ];
          description = "The disk driver used by Hollo to store blobs such as avatars, custom emojis, and other media. Valid values are fs (local filesystem) and s3 (S3-compatible object storage).";
        };
        # fs options
        fsAssetPath = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/hollo";
          description = "The path in the local filesystem where blob assets are stored.";
        };
        # S3 options
        urlBase = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Public URL base of the S3-compatible object storage.";
        };
        region = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "us-east-1";
          description = "Region of the S3-compatible object storage. On some non-S3 services, this can be omitted.";
        };
        bucket = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Bucket name of the S3-compatible object storage.";
        };
        endpointUrl = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Endpoint URL for S3-compatible object storage.";
        };
        forcePathStyle = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to force path-style URLs for S3-compatible object storage.";
        };
        accessKeyId = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Access key for S3-compatible object storage.";
        };
        secretAccessKeyFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Secret key for S3-compatible object storage.";
        };
      };
      settings = {
        port = lib.mkOption {
          type = lib.types.port;
          default = 3000;
          description = "The port number to listen on.";
        };
        secretKeyFile = lib.mkOption {
          type = lib.types.path;
          description = "Secret key for securing the session";
        };
        TZ = lib.mkOption {
          type = lib.types.str;
          default = "UTC";
          example = "America/New_York";
          description = "The time zone of the application. It has to be a valid time zone identifier.";
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
        homeUrl = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "URL to which the homepage will redirect. If not set, the homepage will show the list of accounts on the instance.";
        };
        remoteActorFetchPosts = lib.mkOption {
          type = lib.types.int;
          default = 10;
          description = "Number of recent public posts to fetch from remote actors when they are encountered first time.";
        };
        timelineInboxes = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Setting this to true lets your timelines work like inboxes: all posts visible to your timeline are physically stored in the database, rather than being filtered in real-time as they are displayed. This is useful for relatively larger instances with many incoming posts.";
        };
        allowHTML = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Setting this to `true` allows raw HTML inside Markdown, which is used for formatting posts, bio, etc. This is useful for allowing users to use broader formatting options outside of Markdown, but to avoid XSS attacks, it is still limited to a subset of HTML tags and attributes.";
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
        logFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "The path to the log file. Unlike console output, the log file is written in JSON Lines format which is suitable for structured logging.";
        };
        sentryDSN = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "The DSN of the Sentry project to send error reports and traces to.";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.database.createLocally -> cfg.database.user == "hollo" && cfg.database.name == "hollo";
        message = "Database user and name should be `hollo` when create the database locally.";
      }
      {
        assertion =
          cfg.storage.type == "s3"
          ->
            cfg.storage.urlBase != null
            && cfg.storage.region != null
            && cfg.storage.bucket != null
            && cfg.storage.endpointUrl != null
            && cfg.storage.accessKeyId != null
            && cfg.storage.secretAccessKeyFile != null;
        message = "<option>services.hollo.storage.urlBase</option>, <option>services.hollo.storage.region</option>, <option>services.hollo.storage.bucket</option>, <option>services.hollo.storage.endpointUrl</option>, <option>services.hollo.storage.accessKeyId</option>, <option>services.hollo.storage.secretAccessKeyFile</option> need to be set when <option>services.hollo.storage.type</option> is `s3`";
      }
    ];
    systemd.services.hollo = {
      after = [
        "network-online.target"
      ] ++ lib.optional cfg.database.createLocally "postgresql.service";

      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "hollo";
        Group = "hollo";

        StateDirectory = lib.mkIf (cfg.storage.fsAssetPath == "/var/lib/hollo") "hollo";

        LoadCredential =
          [
            "SECRET_KEY:${cfg.settings.secretKeyFile}"
          ]
          ++ (lib.optional (cfg.database.passwordFile != null) "DB_PW:${cfg.database.passwordFile}")
          ++ (lib.optional (cfg.storage.type == "s3") "S3_ACCESS_KEY:${cfg.storage.secretAccessKeyFile}");

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
        UMask = "0022";
      };

      script =
        ''
          export SECRET_KEY=$(< $CREDENTIALS_DIRECTORY/SECRET_KEY)
        ''
        + lib.optionalString (cfg.database.passwordFile != null) ''
          export DATABASE_PASSWORD=$(< $CREDENTIALS_DIRECTORY/DB_PW)
        ''
        + lib.optionalString (cfg.storage.type == "s3") ''
          export AWS_SECRET_ACCESS_KEY=$(< $CREDENTIALS_DIRECTORY/S3_ACCESS_KEY)
        ''
        + ''
          ${lib.getExe cfg.package}
        '';

      environment = {
        PORT = builtins.toString cfg.settings.port;
        TZ = cfg.settings.TZ;
        BEHIND_PROXY = lib.boolToString cfg.settings.behindProxy;
        ALLOW_PRIVATE_ADDRESS = lib.boolToString cfg.settings.allowPrivateAddress;
        HOME_URL = cfg.settings.homeUrl;
        REMOTE_ACTOR_FETCH_POSTS = builtins.toString cfg.settings.remoteActorFetchPosts;
        TIMELINE_INBOXES = lib.boolToString cfg.settings.timelineInboxes;
        ALLOW_HTML = lib.boolToString cfg.settings.allowHTML;
        LOG_LEVEL = cfg.settings.logLevel;
        LOG_QUERY = lib.boolToString cfg.settings.logQuery;
        LOG_FILE = cfg.settings.logFile;
        SENTRY_DSN = cfg.settings.sentryDSN;
        # database
        DATABASE_HOST = cfg.database.host;
        DATABASE_PORT = builtins.toString cfg.database.port;
        DATABASE_USER = cfg.database.user;
        DATABASE_NAME = cfg.database.name;
        # storage
        DRIVE_DISK = cfg.storage.type;
        FS_ASSET_PATH = cfg.storage.fsAssetPath;
        ASSET_URL_BASE = cfg.storage.urlBase;
        S3_REGION = cfg.storage.region;
        S3_BUCKET = cfg.storage.bucket;
        S3_ENDPOINT_URL = cfg.storage.endpointUrl;
        S3_FORCE_PATH_STYLE = lib.boolToString cfg.storage.forcePathStyle;
        AWS_ACCESS_KEY_ID = cfg.storage.accessKeyId;
        # Drizzle wants to make temp certs
        XDG_DATA_HOME = "/tmp";
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

    users.users.hollo = {
      group = "hollo";
      isSystemUser = true;
    };
    users.groups.hollo = { };
  };

  meta.maintainers = [ lib.maintainers.honnip ];
}
