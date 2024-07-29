{
  config,
  pkgs,
  inputs,
  configLib,
  lib,
  ...
}: {
  services.adguardhome = {
    enable = true;
    mutableSettings = true;
    allowDHCP = true;
  };
}
