{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    w3m
  ];

  programs.aerc = {
    enable = true;
    extraConfig = {
      general.unsafe-accounts-conf = true;
      viwer = {
        pager = "less";
      };
      filters = {
        "text/plain" = "colorize";
        "text/html" = "html | colorize";
      };
    };
  };

  programs.himalaya.enable = true;

  accounts.email.accounts.gmail = {
    address = "gabevenberg@gmail.com";
    primary = true;
    flavor = "gmail.com";
    passwordCommand = "cat ${config.sops.secrets.gmail-password.path}";
    realName = "Gabe Venberg";

    himalaya.enable = true;
    aerc.enable = true;
  };
}
