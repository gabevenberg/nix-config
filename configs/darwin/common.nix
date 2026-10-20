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

  # swap caps lock and left control on every keyboard.
  # nix has no hex literals, so these are HID usage IDs (0x7000000xx) in decimal.
  system.keyboard = {
    enableKeyMapping = true;
    userKeyMapping = [
      {
        # caps lock (0x700000039) -> left control (0x7000000E0)
        HIDKeyboardModifierMappingSrc = 30064771129;
        HIDKeyboardModifierMappingDst = 30064771296;
      }
      {
        # left control -> caps lock
        HIDKeyboardModifierMappingSrc = 30064771296;
        HIDKeyboardModifierMappingDst = 30064771129;
      }
    ];
  };

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    # makes touch id work inside tmux/zellij/screen sessions too
    reattach = true;
  };

  system.primaryUser = config.host.details.user;
  # the account is made by macOS, this only tells nix-darwin and home-manager where it is
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
