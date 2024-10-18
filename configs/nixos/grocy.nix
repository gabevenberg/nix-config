{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  services.grocy = {
    enable = true;
    hostName = "grocy.venberg.xyz";
    dataDir = "/storage/grocy";
    nginx.enableSSL = true;
    settings.currency = "EUR";
  };
}
