{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  sops = lib.mkIf (inputs ? nix-secrets) {
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
    passwordFile = config.sops.secrets.restic-password.path;
    repositoryFile = config.sops.secrets.restic-url.path;
  };
}
