{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  port = "8090";
in {
  sops.secrets = lib.mkIf (inputs ? nix-secrets) {
    restic-server-credentials = {
      sopsFile = "${inputs.nix-secrets}/restic-server";
      format = "binary";
      owner = "restic";
    };
    restic-url = {
      sopsFile = "${inputs.nix-secrets}/restic-client.yaml";
      owner = config.host.details.user;
    };
    restic-password = {
      sopsFile = "${inputs.nix-secrets}/restic-client.yaml";
      owner = config.host.details.user;
    };
  };

  host.restic = {
    enable = true;
    repositoryFile = config.sops.secrets.restic-url.path;
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
