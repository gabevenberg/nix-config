{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.senpai = lib.mkIf (lib.hasAttrByPath ["sops" "secrets" "soju-password"] config) {
    enable = true;
    config = {
      address = "irc.venberg.xyz";
      nickname = "toric";
      password-cmd = ["cat" config.sops.secrets.soju-password.path];
      colors = {
        nicks="extended";
      };
    };
  };
}
