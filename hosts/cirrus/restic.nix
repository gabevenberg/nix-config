{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    restic
  ];

  sops = lib.mkIf (inputs ? nix-secrets) {
    secrets.restic-url = {
      sopsFile = "${inputs.nix-secrets}/restic-client.yaml";
      owner = config.host.user;
    };
    secrets.restic-password = {
      sopsFile = "${inputs.nix-secrets}/restic-client.yaml";
      owner = config.host.user;
    };
  };

  services.restic.backups = lib.mkIf (inputs ? nix-secrets) {
    remote = {
      repositoryFile = config.sops.secrets.restic-url.path;
      passwordFile = config.sops.secrets.restic-password.path;
      initialize = true;
      paths = [
        "/var/lib/radicale"
      ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "4h";
      };
    };
  };
}
