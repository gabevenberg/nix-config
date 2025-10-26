{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself on non-nixos systems.
  programs.home-manager.enable = config.targets.genericLinux.enable;

  nixpkgs.overlays = lib.mkIf (config.targets.genericLinux.enable && (inputs ? nixpkgs-fork)) [
    (final: prev: {
      fork = inputs.nixpkgs-fork.legacyPackages.${prev.system};
    })
  ];

  services.home-manager.autoExpire = lib.mkIf config.targets.genericLinux.enable {
    enable = true;
    store = {
      cleanup = true;
      options = "--delete-older-than 7d";
    };
  };

  # enable flakes on non-nixos systems
  nix =
    lib.mkIf config.targets.genericLinux.enable
    {
      package = pkgs.nix;
      settings = {
        experimental-features = ["nix-command" "flakes"];
        max-jobs = "auto";
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
  imports = [
    ../../modules/nixos/hostopts.nix
    ../../modules/home-manager
  ];
}
