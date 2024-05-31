{
  config,
  pkgs,
  lib,
  ...
}: {
  services.nextcloud-client.enable = true;
  services.gnome-keyring.enable = true;
}
