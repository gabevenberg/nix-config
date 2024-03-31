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
            "#lobsters"
            "#nixos"
            "#rust"
            "#git"
            "#programming"
            "#hardware"
            "#neovim"
            "#kernel"
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
