{
  config,
  pgks,
  lib,
  ...
}: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
