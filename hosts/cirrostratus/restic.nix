{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  port = "8090";
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
      paths = [
        "/storage/syncthing"
        "/storage/factorio"
      ];
      pruneOpts=[
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
