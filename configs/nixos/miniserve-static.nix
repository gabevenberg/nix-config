{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  port = "8080";
in {
  systemd.services.miniserve = {
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    description = "A directory listing miniserve instance";
    serviceConfig = {
      ExecStart = lib.concatStringsSep " " [
        "${pkgs.miniserve}/bin/miniserve"
        "--enable-tar-gz"
        "--show-wget-footer"
        "--readme"
        "--port ${port}"
        "--qrcode"
        # "--no-symlinks"
        "--interfaces 127.0.0.1"
        "/storage/miniserve"
      ];
    };
  };
  services.nginx.virtualHosts."static.venberg.xyz" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${port}";
    };
  };
}
