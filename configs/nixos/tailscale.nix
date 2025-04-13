{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
}
