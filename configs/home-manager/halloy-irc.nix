{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.halloy = lib.mkIf (lib.hasAttrByPath ["sops" "secrets" "soju-password"] config) {
    enable = true;
    settings = {
      servers.soju = {
        server = "irc.venberg.xyz";
        nickname = "toric";
        port = 6697;
        sasl.plain = {
          username = "toric";
          password_file = config.sops.secrets.soju-password.path;
        };
      };
      buffer.chathistory.infinite_scroll = true;
    };
  };
}
