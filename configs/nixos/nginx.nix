{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    commonHttpConfig = ''
      add_header X-Clacks-Overhead "GNU Terry Pratchett";
      add_header X-Clacks-Overhead "GNU Bram Moolenaar";
    '';
    # other Nginx options
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "gabevenberg@gmail.com";
  };
  networking.firewall.allowedTCPPorts = [443 80];
}
