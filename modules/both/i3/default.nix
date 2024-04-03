{
  config,
  pkgs,
  lib,
  ...
}: {
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # enable flakes
  nix =
    lib.mkIf config.targets.genericLinux.enable
    {
      package = pkgs.nix;
      settings.experimental-features = ["nix-command" "flakes"];
      settings.max-jobs = "auto";
      gc.automatic = true;
    };
}
