{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    host.restic = {
      enable = lib.mkEnableOption "enable restic";
      passwordFile = lib.mkOption {
        type = lib.types.path;
        description = "path to the file containing the restic repository password.";
      };
      repositoryFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        description = "path to the file containing the restic repository url/path";
        default = null;
      };
      repository = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "restic repository url/path";
      };
      server = {
        enable = lib.mkEnableOption "enable restic server (must have nginx enabled and setup, and host.restic.passwordFile populated.)";
        repositoryPath = lib.mkOption {
          type = lib.types.path;
          description = "path of repository";
        };
        htpasswdPath = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          description = "path to the repositories .htpasswd file";
          default = null;
        };
        domain = lib.mkOption {
          type = lib.types.str;
          description = "domain name to serve the restic server under. (for nginx virtualHosts)";
        };
        port = lib.mkOption {
          type = lib.types.str;
          description = "(internal) port to use between nginx and restic-server";
        };
      };
      backups = lib.mkOption {
        description = "backups to create";
        default = {};
        type = lib.types.attrsOf (lib.types.submodule ({name, ...}: {
          options = {
            paths = lib.mkOption {
              type = lib.types.listOf lib.types.path;
              description = "paths to back up.";
            };
            preBackupCommands = lib.mkOption {
              type = lib.types.nullOr lib.types.lines;
              description = "commands to run before the start of the backup.";
              default = null;
            };
            postBackupCommands = lib.mkOption {
              type = lib.types.nullOr lib.types.lines;
              description = "commands to run after the backup is finished.";
              default = null;
            };
          };
        }));
      };
    };
  };
  config = let
    cfg = config.host.restic;
    timer = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "4h";
    };
    pruneOpts = [
      "--keep-within 14d"
      "--keep-daily 14"
      "--keep-weekly 8"
      "--keep-monthly 12"
      "--keep-yearly 10"
    ];
  in {
    environment.systemPackages =
      lib.mkIf
      (cfg.server.enable || cfg.enable)
      (with pkgs; [
        restic
      ]);

    services.restic.server = lib.mkIf cfg.server.enable {
      enable = true;
      appendOnly = true;
      dataDir = cfg.server.repositoryPath;
      listenAddress = "127.0.0.1:${cfg.server.port}";
      htpasswd-file = cfg.server.htpasswdPath;
    };

    services.nginx.virtualHosts =
      lib.mkIf (
        cfg.server.enable
        && (lib.asserts.assertMsg
          (config.services.nginx.enable == true)
          "NGINX must be enabled")
      )
      {
        "${cfg.server.domain}" = {
          enableACME = lib.asserts.assertMsg (
            config.security.acme.acceptTerms
            == true
            && config.security.acme.defaults.email != null
          ) "ACME must be setup";
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://localhost:${cfg.server.port}";
          };
        };
      };

    services.restic.backups = lib.mkMerge [
      (lib.mkIf cfg.server.enable {
        prune = {
          repository = cfg.server.repositoryPath;
          passwordFile = cfg.passwordFile;
          initialize = true;
          runCheck = true;
          paths = null;
          timerConfig = timer;
          pruneOpts = pruneOpts;
        };
      })
      (
        lib.mkIf cfg.enable (
          lib.mapAttrs (
            name: backup: {
              repositoryFile = cfg.repositoryFile;
              repository = cfg.repository;
              passwordFile = cfg.passwordFile;
              timerConfig = timer;
              backupPrepareCommand = backup.preBackupCommands;
              backupCleanupCommand = backup.postBackupCommands;
              paths = backup.paths;
            }
          )
          cfg.backups
        )
      )
    ];
  };
}
