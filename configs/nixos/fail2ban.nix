{
  config,
  pkgs,
  inputs,
  lib,
  myLib,
  ...
}: {
  services.fail2ban = {
    enable = true;
    bantime-increment.enable = true;
    bantime-increment.maxtime = "1w";
    extraPackages = [pkgs.ipset];
    banaction = "iptables-ipset-proto6-allports";
  };
}
