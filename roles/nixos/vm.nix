{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services.qemuGuest.enable = true;
  host.isVm = true;
}
