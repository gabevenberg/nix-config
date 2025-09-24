{
  config,
  pkgs,
  inputs,
  lib,
  myLib,
  ...
}: {
  imports = [
    ./fail2ban.nix
  ];
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
    settings.PasswordAuthentication = false;
  };
  # so we dont have to set TERM everytime we ssh in.
  environment.systemPackages = with pkgs; [
    kitty.terminfo
    ghostty.terminfo
    alacritty.terminfo
    rio.terminfo
  ];

  users.users.root.openssh.authorizedKeys.keys = lib.mkDefault (
    if inputs ? nix-secrets
    then (myLib.dirToStrings "${inputs.nix-secrets}/public-keys")
    else []
  );
  # if it can log into root, it should also be able to log in to the main user.
  users.users.${config.host.details.user}.openssh.authorizedKeys.keys =
    config.users.users.root.openssh.authorizedKeys.keys;
}
