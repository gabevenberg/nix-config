{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  services.radicale = {
    enable = true;
    settings = {
      auth = {
        type = "htpasswd";
        htpasswd_encryption = "md5";
        htpasswd_filename = config.sops.secrets.radicale-users.path;
      };
    };
  };
  networking.firewall.allowedTCPPorts = [5232];

  services.nginx.virtualHosts."cal.venberg.xyz" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:5232";
    };
  };

  imports = [./nginx.nix];
}
