{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
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

  time.timeZone = lib.mkDefault "America/Chicago";
  # Select internationalisation properties.
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = lib.mkDefault "us";
    xkb.variant = lib.mkDefault "";
  };

  # packages that should be on every system.
  environment.systemPackages = [pkgs.neovim];

  programs.zsh.enable = lib.mkDefault true;
  environment.shells = lib.mkDefault [pkgs.zsh];
  users.mutableUsers = false;
  users.users.${config.host.user} = {
    isNormalUser = true;
    hashedPassword = lib.removeSuffix "\n" (builtins.readFile "${inputs.nix-secrets}/password-hash");
    description = config.host.fullName;
    shell = pkgs.zsh;
    extraGroups = ["wheel"];
  };
  # users.users.root.password = lib.removeSuffix "\n" (builtins.readFile "${inputs.nix-secrets}/password-hash");

  imports = [
    ../../modules/hostopts.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {inherit inputs;};
}
