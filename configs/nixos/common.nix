{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  # hash for "nixos"
  defaultPasswordHash = "$y$j9T$u0O3PELyRv3GOemCReQhA0$Qb4Sl6dXnafYwZeDYrJGwS4xp3v6vGriWFMYomHH2w3";
in {
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      trusted-users = ["root" "gabe"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  time.timeZone = lib.mkDefault "Europe/Berlin";
  # Select internationalisation properties.
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = lib.mkDefault "us";
    xkb.variant = lib.mkDefault "";
  };

  # packages that should be on every system.
  environment.systemPackages = with pkgs; [
    neovim
    rsync
  ];

  programs.zsh.enable = lib.mkDefault true;
  environment.shells = lib.mkDefault [pkgs.zsh];
  # if we arent setting our password from nix secrets, we need to allow changing it.
  users.mutableUsers = !inputs ? nix-secrets;
  users.users.${config.host.user} = {
    isNormalUser = true;
    hashedPassword =
      if inputs ? nix-secrets
      then (lib.removeSuffix "\n" (builtins.readFile "${inputs.nix-secrets}/password-hash"))
      else defaultPasswordHash;
    description = config.host.fullName;
    shell = pkgs.zsh;
    extraGroups = ["wheel"];
  };
  users.users.root.password =
    if inputs ? nix-secrets
    then (lib.removeSuffix "\n" (builtins.readFile "${inputs.nix-secrets}/password-hash"))
    else defaultPasswordHash;

  imports = [
    ../../modules/nixos
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {inherit inputs;};
}
