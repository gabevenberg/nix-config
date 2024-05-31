{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = lib.mkDefault pkgs.pinentry-tty;
  };
}
