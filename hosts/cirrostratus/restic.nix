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
      owner="restic";
    };
  };
  environment.systemPackages = with pkgs; [
    restic
  ];
}
