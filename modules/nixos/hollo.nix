self:
{
  config,
  options,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.hollo;
  opts = options.services.hollo;
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
        urlBase = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "https://media.hollo.social";
          description = ''
            Public URL base of the S3-compatible object storage.

            When using the filesystem storage, you should set this to serve local filesystem files via web access, typically in the format `https://<host>/assets`, e.g., `https://hollo.example.com/assets`.
          '';
        };
        # fs options
        fsPath = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/hollo";
          description = "The path in the local filesystem where blob assets are stored.";
        };
        # S3 options
        region = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "auto";
          example = "us-east-1";
          description = "The region of the S3-compatible object storage. On some non-S3 services, this can be omitted.";
        };
        bucket = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "hollo";
          description = "The bucket name of the S3-compatible object storage.";
        };
        endpointUrl = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "https://s3.us-east-1.amazonaws.com";
          description = "The endpoint URL for S3-compatible object storage.";
        };
        forcePathStyle = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to force path-style URLs for S3-compatible object storage.";
        };
        accessKeyId = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "The access key for S3-compatible object storage.";
        };
        secretAccessKeyFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "The secret key for S3-compatible object storage.";
        };
      };
      settings = {
        port = lib.mkOption {
          type = lib.types.port;
          default = 3000;
          description = "The port number to listen on.";
        };
        bind = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "The address to listen on. Must be a valid IP address or localhost.";
        };
        secretKeyFile = lib.mkOption {
          type = lib.types.path;
          description = ''
            The secret key for securing the session. Must be at least 44 characters long. You can generate a random secret key using the following command:
            ```shell
              openssl rand -hex 32
            ```
          '';
        };
        TZ = lib.mkOption {
          type = lib.types.str;
          default = "UTC";
          example = "America/New_York";
          description = "The time zone of the application. It has to be a valid time zone identifier.";
        };
        nodeType = lib.mkOption {
          type = lib.types.enum [
            "all"
            "web"
            "worker"
          ];
          default = "all";
          description = ''
            Controls which components run in this process. Valid values are:
            - `all` (default): Run web server, Fedify message queue, import worker, cleanup worker and remote replies scrape worker
            - `web`: Run only the web server (HTTP API)
            - `worker`: Run only workers (Fedify message queue + import worker + cleanup worker + remote replies scrape worker)

            This allows separating the web server from background workers for better scalability. When running high-traffic instances with many followers, separating workers can improve performance.
          '';
        };
        behindProxy = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Set this to true if Hollo is behind a reverse proxy. If you place the Hollo behind an L7 load balancer (you usually should do this), turn this on.Whether Hollo is behind a reverse proxy.";
        };
        handleHost = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            The fediverse handle domain when running a [split-domain WebFinger setup](https://docs.hollo.social/install/split-domain/). When set, fediverse handles take the form ``@user@HANDLE_HOST` even though Hollo itself is served at [`WEB_ORIGIN`](https://docs.hollo.social/install/env/#web_origin).

            Must be set together with `WEB_ORIGIN`; setting only one is a startup error. Configure both _before_ creating the first account — changing the handle domain after federation has begun breaks remote follow relationships.
          '';
        };
        webOrigin = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            The origin (scheme + host) where Hollo’s ActivityPub server actually runs in a [split-domain WebFinger setup](https://docs.hollo.social/install/split-domain/), e.g. `https://ap.example.com`. Actor URIs, inbox URLs, and other federation endpoints are built under this origin.

            Must be set together with [HANDLE_HOST](https://docs.hollo.social/install/env/#handle_host); setting only one is a startup error.
          '';
        };
        allowPrivateAddress = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Setting this to true disables SSRF (Server-Side Request Forgery) protection.

            Turn on to test in local network.
          '';
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
        remoteRepliesScrapeDepth = lib.mkOption {
          type = lib.types.int;
          default = 2;
          description = "The number of remote reply levels to scrape in background worker jobs. Set this to 0 to disable remote replies scraping.";
        };
        remoteRepliesScrapeMaxItems = lib.mkOption {
          type = lib.types.int;
          default = 100;
          description = "The maximum number of reply items to persist from a single remote replies scraping job.";
        };
        remoteRepliesScrapeIntervalSeconds = lib.mkOption {
          type = lib.types.int;
          default = 5;
          description = "The minimum delay between remote replies scraping requests to the same origin.";
        };
        remoteRepliesScrapeBackoffSeconds = lib.mkOption {
          type = lib.types.int;
          default = 300;
          description = "The fallback delay before retrying a remote replies scraping job after an HTTP 429 response when the remote server does not provide `Retry-After`.";
        };
        remoteRepliesScrapeCooldownSeconds = lib.mkOption {
          type = lib.types.int;
          default = 300;
          description = "The time window during which completed remote replies scraping jobs suppress duplicate jobs for the same replies collection.";
        };
        mediaProxy = lib.mkOption {
          type = lib.types.enum [
            "off"
            "proxy"
            "cache"
          ];
          default = "off";
          description = ''
            Controls how Hollo serves media that lives on remote servers (avatars, headers, attachments, custom emojis, preview-card images). Valid values are:

            - `off` (default): the Mastodon API and web UI hand the original remote URL to clients, matching the historical behaviour.
            - `proxy`: every remote media URL is rewritten to a signed `/proxy/<sig>/<b64url>` path served by Hollo itself. Hollo streams the upstream bytes through on each request and does not write them to disk. Clients see only the Hollo origin, sidestepping remote CORS configuration and leaks of the visitor’s IP address.
            - `cache`: same URL rewriting as `proxy`, but the streamed body is persisted to the configured storage backend as `proxy/<sha256>.bin` alongside a content-type sidecar at `proxy/<sha256>.json`. Subsequent requests skip the upstream fetch. Remote actor avatars for accounts with an approved follow relationship to the local account are also prefetched into this cache when the actor is stored or refreshed. The admin dashboard at _/thumbnail_cleanupi_ can purge the cache on demand.

            Disk caching must be requested explicitly with `cache`.

            In `proxy` and `cache` modes, Hollo refuses non-HTTP(S) schemes, runs SSRF checks on each upstream URL and every redirect target, enforces a 32 MiB body cap, and never proxies image/svg+xml — SVG could carry inline scripts that execute under the Hollo origin.
          '';
        };
        remoteMediaThumbnails = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Controls whether Hollo downloads remote media attachments to generate a local WebP thumbnail when it ingests a post.

            When set to `off`, Hollo skips the upstream fetch and Sharp pipeline entirely for incoming attachments, storing the remote URL itself as the thumbnail URL. Combined with `MEDIA_PROXY=proxy` or `cache`, clients still see a same-origin URL at render time; with `MEDIA_PROXY=off`, they receive the upstream URL directly. This frees up significant disk space on instances that ingest many media-heavy posts.
          '';
        };
        remoteActorStalenessDays = lib.mkOption {
          type = lib.types.int;
          default = 7;
          description = "The number of days after which a remote actor’s cached data is considered stale. When a stale actor is encountered during activity processing (e.g., receiving a boost or a new post), their profile data will be refreshed asynchronously.";
        };
        refreshActorsOnInteraction = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "When set to `true`, checks for stale actor data on all incoming activities (likes, emoji reactions, follows, etc.). When `false` (default), only checks on activities that appear in timelines (Announce, Create).";
        };
        timelineInboxes = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Setting this to `false` disables timeline inbox mode. When enabled (the default), all posts visible to your timeline are physically stored in the database, rather than being filtered in real-time as they are displayed. This is useful for relatively larger instances with many incoming posts.

            This option defaults to `true` as of Hollo 0.9.0. It will be removed entirely in Hollo 1.0.0, when timeline inbox mode will be the only behavior.
          '';
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
          description = "The log level for the application.";
        };
        logQuery = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Set this to `true` to log SQL queries.";
        };
        logFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "The path to the log file. Unlike console output, the log file uses structured logging format (JSON Lines by default).";
        };
        logFileFormat = lib.mkOption {
          type = lib.types.enum [
            "jsonl"
            "logfmt"
          ];
          default = "jsonl";
          description = ''
            The format of the log file set by `[LOG_FILE](https://docs.hollo.social/install/env/#log_file)``. Valid values are:

            - `jsonl` (default): [JSON Lines](https://jsonlines.org/) format, one JSON object per line. Suitable for log aggregation tools that parse structured JSON.
            - `logfmt`: [logfmt](https://brandur.org/logfmt) format, a key=value pair per line. Human-readable and compatible with tools like [Loki](https://grafana.com/oss/loki/) and [Heroku’s log drains](https://devcenter.heroku.com/articles/log-drains).
          '';
        };
        sentryDSN = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "The DSN of the Sentry project to send error reports and traces to.";
        };
        fedifyDebug = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Set this to `true` to enable the [Fedify debugger](https://fedify.dev/manual/debug), an embedded real-time debug dashboard for inspecting ActivityPub traces and activities. When enabled, the debug dashboard is available at `/__debug__/`.";
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
            cfg.storage.region != null
            && cfg.storage.bucket != null
            && cfg.storage.endpointUrl != null
            && cfg.storage.accessKeyId != null
            && cfg.storage.secretAccessKeyFile != null;
        message = "${opts.storage.region}, ${opts.storage.bucket}, ${opts.storage.endpointUrl}, ${opts.storage.accessKeyId}, ${opts.storage.secretAccessKeyFile} need to be set when ${opts.storage.type} is `s3`";
      }
    ];
    systemd.services.hollo = {
      after = [
        "network-online.target"
      ]
      ++ lib.optional cfg.database.createLocally "postgresql.service";

      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "hollo";
        Group = "hollo";

        StateDirectory = lib.mkIf (cfg.storage.fsPath == "/var/lib/hollo") "hollo";

        LoadCredential = [
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

      script = ''
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
        BIND = cfg.settings.bind;
        TZ = cfg.settings.TZ;
        NODE_TYPE = cfg.settings.nodeType;
        BEHIND_PROXY = lib.boolToString cfg.settings.behindProxy;
        HANDLE_HOST = cfg.settings.handleHost;
        WEB_ORIGIN = cfg.settings.webOrigin;
        ALLOW_PRIVATE_ADDRESS = lib.boolToString cfg.settings.allowPrivateAddress;
        HOME_URL = cfg.settings.homeUrl;
        REMOTE_ACTOR_FETCH_POSTS = builtins.toString cfg.settings.remoteActorFetchPosts;
        REMOTE_REPLIES_SCRAPE_DEPTH = builtins.toString cfg.settings.remoteRepliesScrapeDepth;
        REMOTE_REPLIES_SCRAPE_MAX_ITEMS = builtins.toString cfg.settings.remoteRepliesScrapeMaxItems;
        REMOTE_REPLIES_SCRAPE_INTERVAL_SECONDS = builtins.toString cfg.settings.remoteRepliesScrapeIntervalSeconds;
        REMOTE_REPLIES_SCRAPE_BACKOFF_SECONDS = builtins.toString cfg.settings.remoteRepliesScrapeBackoffSeconds;
        REMOTE_REPLIES_SCRAPE_COOLDOWN_SECONDS = builtins.toString cfg.settings.remoteRepliesScrapeCooldownSeconds;
        MEDIA_PROXY = cfg.settings.mediaProxy;
        REMOTE_MEDIA_THUMBNAILS = lib.boolToString cfg.settings.remoteMediaThumbnails;
        REMOTE_ACTOR_STALENESS_DAYS = builtins.toString cfg.settings.remoteActorStalenessDays;
        REFRESH_ACTORS_ON_INTERACTION = lib.boolToString cfg.settings.refreshActorsOnInteraction;
        TIMELINE_INBOXES = lib.boolToString cfg.settings.timelineInboxes;
        ALLOW_HTML = lib.boolToString cfg.settings.allowHTML;
        LOG_LEVEL = cfg.settings.logLevel;
        LOG_QUERY = lib.boolToString cfg.settings.logQuery;
        LOG_FILE = cfg.settings.logFile;
        LOG_FILE_FORMAT = cfg.settings.logFileFormat;
        SENTRY_DSN = cfg.settings.sentryDSN;
        FEDIFY_DEBUG = lib.boolToString cfg.settings.fedifyDebug;
        # database
        DATABASE_HOST = cfg.database.host;
        DATABASE_PORT = builtins.toString cfg.database.port;
        DATABASE_USER = cfg.database.user;
        DATABASE_NAME = cfg.database.name;
        # storage
        DRIVE_DISK = cfg.storage.type;
        STORAGE_URL_BASE = cfg.storage.urlBase;
        FS_STORAGE_PATH = cfg.storage.fsPath;
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
