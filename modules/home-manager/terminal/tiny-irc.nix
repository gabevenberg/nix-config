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
            "##programming"
            "##rust"
            "#nixos"
            "#git"
            "#neovim"
            "#kernel"
            "#hardware"
            "#lobsters"
            "#gamingonlinux"
          ];
          sasl = {
            username = "toric";
            password = {
              command = "pass show libera";
            };
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
