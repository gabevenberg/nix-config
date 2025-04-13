{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services.qemuGuest.enable = true;
  host.details.isVm = true;
}
