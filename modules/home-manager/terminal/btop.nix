{
  config,
  pkgs,
  lib,
  ...
}: {
  options.user.btop.enable = lib.mkEnableOption "enable btop";
  config = lib.mkIf config.user.btop.enable {
    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
  };
}
