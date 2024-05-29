{
  config,
  lib,
  pkgs,
  ...
}: {
  options.user.zellij.enable = lib.mkEnableOption "enable zellij";
  config = lib.mkIf config.user.zellij.enable {
    programs.zellij.enable = true;
    home.file = {
      ".config/zellij/config.kdl".source = ./config.kdl;
    };
  };
}
