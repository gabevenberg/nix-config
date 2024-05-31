{
  config,
  pkgs,
  lib,
  ...
}: {
  options.user.irssi.enable = lib.mkEnableOption "enable irssi";
  config = lib.mkIf config.user.irssi.enable {
    programs.irssi = {
      enable = true;
      networks = {
        liberachat = {
          nick = "toric";
          server = {
            address = "irc.libera.chat";
            port = 6697;
            autoConnect = true;
            ssl = {
              enable = true;
              certificateFile = "${config.home.homeDirectory}/keys/certs/irc.pem";
              verify = true;
            };
          };
          channels = {
            libera.autoJoin = true;
            linux.autoJoin = true;
            programming.autoJoin = true;
            rust.autoJoin = true;
            nixos.autoJoin = true;
            git.autoJoin = true;
            neovim.autoJoin = true;
            kernel.autoJoin = true;
            hardware.autoJoin = true;
            lobsters.autoJoin = true;
            gamingonlinux.autoJoin = true;
          };
        };
      };
    };
  };
}
