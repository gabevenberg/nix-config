{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  port = "5050";
in {
  # this is so you can start miniserve in a directory to temporarily allow people to upload:
  # miniserve --port=5050 --no-symlinks --upload-files --mkdir --show-wget-footer --auth user:pass ./
  environment.systemPackages = with pkgs; [
    miniserve
  ];
  services.nginx.virtualHosts."upload.venberg.xyz" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${port}";
    };
  };
}
