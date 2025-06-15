{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  services.adguardhome = {
    enable = true;
    mutableSettings = true;
    allowDHCP = true;
    openFirewall=true;
    port=80;
  };
}
