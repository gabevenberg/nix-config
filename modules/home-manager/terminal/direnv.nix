{
  config,
  pgks,
  lib,
  ...
}: {
  options.user.direnv.enable = lib.mkEnableOption "enable direnv";
  config= lib.mkIf config.user.direnv.enable{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  };
}
