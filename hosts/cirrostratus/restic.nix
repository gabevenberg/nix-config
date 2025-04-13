{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  port = "8090";
in {
  sops = lib.mkIf (inputs ? nix-secrets) {
    secrets.restic-server-credentials = {
      sopsFile = "${inputs.nix-secrets}/restic-server";
      format = "binary";
      owner = "restic";
    };
    secrets.restic-url = {
      sopsFile = "${inputs.nix-secrets}/restic-client.yaml";
      owner = config.host.details.user;
    };
    secrets.restic-password = {
      sopsFile = "${inputs.nix-secrets}/restic-client.yaml";
      owner = config.host.details.user;
    };
  };

  host.restic = {
    enable = true;
    repository = "/backup/restic/";
    passwordFile = config.sops.secrets.restic-password.path;
    server = {
      enable = true;
      htpasswdPath = config.sops.secrets.restic-server-credentials.path;
      domain = "restic.venberg.xyz";
      port = port;
      repositoryPath = "/backup/restic";
    };
  };

  host.restic.backups.syncthing = {
    paths = ["/storage/syncthing"];
  };
}
