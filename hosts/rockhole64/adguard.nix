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
  networking.firewall.allowedUDPPorts=[53 67 546 547];
}
