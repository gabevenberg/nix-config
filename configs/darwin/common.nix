{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  nix = {
    package = pkgs.nixVersions.stable;
    optimise.automatic = true;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" config.host.details.user];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.overlays = lib.mkIf (inputs ? nixpkgs-fork) [
    (final: prev: {
      fork = inputs.nixpkgs-fork.legacyPackages.${prev.stdenv.hostPlatform.system};
    })
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # packages that should be on every system.
  environment.systemPackages = with pkgs; [
    rsync
  ];

  programs.zsh.enable = lib.mkDefault true;

  system.primaryUser = config.host.details.user;
  # the account itself is made by macOS, this only tells nix-darwin and home-manager where it lives.
  users.users.${config.host.details.user} = {
    home = "/Users/${config.host.details.user}";
    description = config.host.details.fullName;
  };

  imports = [
    ../../modules/nixos/hostopts.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {inherit inputs;};
}
