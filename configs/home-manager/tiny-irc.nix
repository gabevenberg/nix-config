{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.tiny = {
    enable = true;
    settings = {
      servers = [
        {
          addr = "irc.libera.chat";
          alias = "libera";
          port = 6697;
          tls = true;
          realname = "Gabe Venberg";
          nicks = ["toric"];
          join = [
            "#libera"
            "#linux"
            "#archlinux"
            "#nixos"
            "#neovim"
            "##programming"
            "##rust"
            "#zig"
            "#git"
            "#hardware"
            "#3dprinting"
            "#lobsters"
            "#gamingonlinux"
            "##chat"
          ];
          sasl = lib.mkIf (lib.hasAttrByPath ["sops" "secrets" "irc-cert"] config) {
            username = "toric";
            pem = config.sops.secrets.irc-cert.path;
          };
        }
        {
          addr = "mbrserver.com";
          alias = "MBR";
          port = 6667;
          tls = false;
          nicks = ["toric"];
          realname = "Toric";
          join = [
            "#general"
            "#spellware"
          ];
        }
      ];
      defaults = {
        # ignore join/leave messages
        ignore = true;
        nicks = ["toric"];
        realname = "Gabe Venberg";
        # tls = true;
      };
    };
  };
}
