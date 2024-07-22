{
  config,
  pkgs,
  inputs,
  configLib,
  lib,
  ...
}: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
}
