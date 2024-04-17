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
            "#git"
            "#kernel"
            "#hardware"
            "#lobsters"
            "#gamingonlinux"
            "##chat"
          ];
          sasl = {
            username = "toric";
            # password = {
            #   command = "pass show libera";
            # };
            pem = "${config.home.homeDirectory}/keys/certs/irc.pem";
          };
        }
      ];
      defaults = {
        nicks = ["toric"];
        realname = "Gabe Venberg";
        tls = true;
      };
    };
  };
}
