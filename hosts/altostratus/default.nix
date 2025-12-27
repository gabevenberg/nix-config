{
  inputs,
  myLib,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {inherit inputs myLib;};
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    ./hardware-config.nix
    ../../configs/nixos/common.nix
    ../../configs/nixos/sshd.nix
    ../../configs/nixos/secrets.nix
    ../../configs/nixos/tailscale.nix
    ../../configs/nixos/interactive-networking.nix
    ../../configs/nixos/sound.nix
    ../../roles/nixos/embedded-dev
    ({
      config,
      pkgs,
      lib,
      ...
    }: {
      hardware.enableRedistributableFirmware = true;
      nixpkgs.hostPlatform ="x86_64-linux";
      host.details = {
        user = "gabe";
        fullName = "Gabe Venberg";
        gui.enable = false;
      };
      networking.hostName = "altostratus"; # Define your hostname.
      networking.hostId = "c62c7ef6";

      # home-manager.sharedModules = [
      #   inputs.sops-nix.homeManagerModules.sops
      # ];
      home-manager.users.${config.host.details.user} = {
        inputs,
        osConfig,
        lib,
        ...
      }: {
        host.details = osConfig.host.details;
        user = {
          git = {
            profile = {
              name = config.host.details.fullName;
              email = "gabevenberg@gmail.com";
            };
            workProfile = {
              enable = true;
              email = "gabriel.venberg@assistme.io";
            };
          };
        };
        imports = [
          ../../roles/home-manager/minimal-terminal.nix
          ../../configs/home-manager/common.nix
          # ../../configs/home-manager/secrets.nix
        ];

        # sops = lib.mkIf (inputs ? nix-secrets) {
        #   secrets = {
        #   };
        # };
      };

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = false;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.05"; # Did you read the comment?
    })
  ];
}
