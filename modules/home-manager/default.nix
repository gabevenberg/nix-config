{
  config,
  pkgs,
  lib,
  ...
}: {
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself on non-nixos systems.
  programs.home-manager.enable = config.targets.genericLinux.enable;

  # enable flakes on non-nixos systems
  nix =
    lib.mkIf config.targets.genericLinux.enable
    {
      package = pkgs.nix;
      settings.experimental-features = ["nix-command" "flakes"];
      settings.max-jobs = "auto";
      gc.automatic = true;
    };
  imports = [
    ../hostopts.nix
  ];
}
