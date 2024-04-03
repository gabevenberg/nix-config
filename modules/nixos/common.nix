{
  config,
  pkgs,
  ...
}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # packages that should be on every system.
  environment.systemPackages = with pkgs; [
    vi # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  ];
}
