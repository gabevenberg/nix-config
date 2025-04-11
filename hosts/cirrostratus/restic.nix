{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  port = "8090";
  # TODO: I should really make restic a custom module at this point, with an enable option, a option for being the host,
  # and the ability to add paths and pre/post commands from multiple places.
  preBackup = pkgs.writeShellScriptBin "mc-docker-pre-backup" ''
    set -euxo pipefail

    docker exec minecraft rcon-cli "say server backing up, expect minor lag"
    sleep 10
    docker exec minecraft rcon-cli "save-all flush"
    docker exec minecraft rcon-cli "save-off"
    sleep 10
  '';
  postBackup = pkgs.writeShellScriptBin "mc-docker-post-backup" ''
    set -euxo pipefail

    docker exec minecraft rcon-cli "save-on"
    docker exec minecraft rcon-cli "say server backup succsessful!"
  '';
in {
  services.restic.server = lib.mkIf (inputs ? nix-secrets) {
    enable = true;
    appendOnly = true;
    dataDir = "/backup/restic";
    listenAddress = "127.0.0.1:${port}";
  };
  services.nginx.virtualHosts."restic.venberg.xyz" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${port}";
    };
  };
  sops = lib.mkIf (inputs ? nix-secrets) {
    secrets.restic-server-credentials = {
      sopsFile = "${inputs.nix-secrets}/restic-server";
      format = "binary";
      path = "/backup/restic/.htpasswd";
      owner = "restic";
    };
    secrets.restic-url = {
      sopsFile = "${inputs.nix-secrets}/restic-client.yaml";
      owner = config.host.user;
    };
    secrets.restic-password = {
      sopsFile = "${inputs.nix-secrets}/restic-client.yaml";
      owner = config.host.user;
    };
  };

  environment.systemPackages = with pkgs; [
    restic
  ];

  services.restic.backups = lib.mkIf (inputs ? nix-secrets) {
    local = {
      repositoryFile = "/backup/restic/";
      passwordFile = config.sops.secrets.restic-password.path;
      initialize = true;
      backupPrepareCommand = "${preBackup}/bin/mc-docker-pre-backup";
      backupCleanupCommand = "${postBackup}/bin/mc-docker-post-backup";
      paths = [
        "/storage/syncthing"
        "/storage/factorio"
        "/storage/minecraft"
      ];
      pruneOpts = [
        "--keep-within 14d"
        "--keep-daily 14"
        "--keep-weekly 8"
        "--keep-monthly 12"
        "--keep-yearly 10"
      ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "4h";
      };
    };
  };
}
