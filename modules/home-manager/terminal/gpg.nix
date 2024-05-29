{
  config,
  pkgs,
  lib,
  ...
}: {
  options.user.gpg.enable = lib.mkEnableOption "enable gpg";
  config = lib.mkIf config.user.gpg.enable {
    programs.gpg.enable = true;

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryPackage = lib.mkDefault pkgs.pinentry-tty;
    };
  };
}
