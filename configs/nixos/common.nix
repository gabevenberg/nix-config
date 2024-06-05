{
  config,
  pkgs,
  inputs,
  outputs,
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
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  ];

  imports = [
    ../../modules/hostopts.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {inherit inputs outputs;};
}
