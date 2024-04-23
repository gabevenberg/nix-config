{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    home.enable-speech = lib.mkEnableOption "espeak";
  };

  config =
    lib.mkIf config.home.enable-speech
    {
      home.shellAliases = {
        say = "espeak -p 10 -s 150 -a 200";
      };
      home.packages = with pkgs; [
        espeak
      ];
      programs.nushell.extraConfig = ''
        alias say = espeak -p 10 -s 150 -a 200
      '';
    };
}
