{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.himalaya.enable = true;

  programs.aerc = {
    enable = true;
    extraConfig.general.unsafe-accounts-conf = true;
  };
  accounts.email.accounts.gmail = {
    address = "gabevenberg@gmail.com";
    primary = true;
    flavor = "gmail.com";
    passwordCommand = "cat ~/keys/plaintext/gmail";
    realName = "Gabe Venberg";

    himalaya.enable = true;
    aerc.enable = true;
  };
}
