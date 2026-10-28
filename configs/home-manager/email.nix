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
      viewer = {
        pager = "less";
      };
      filters = {
        "text/plain" = "colorize";
        "text/html" = "w3m -T text/html | colorize";
      };
    };
  };

  programs.himalaya.enable = true;

  accounts.email.accounts.gmail = lib.mkIf (lib.hasAttrByPath ["sops" "secrets" "gmail-password"] config) {
    address = "gabevenberg@gmail.com";
    primary = true;
    flavor = "gmail.com";
    passwordCommand = "cat ${config.sops.secrets.gmail-password.path}";
    realName = "Gabe Venberg";

    # TODO: Himalaya has grown a bunch, integrate their ecosystem one day.
    # Also watch meli.
    aerc.enable = true;
  };
}
