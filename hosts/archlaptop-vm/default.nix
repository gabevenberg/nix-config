{
  inputs,
  myLib,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs myLib;};
  # > Our main nixos configuration file <
  modules = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ../../roles/nixos/graphical-vm.nix
    ../../configs/nixos/common.nix
    ../../configs/nixos/printing.nix
    ../../configs/nixos/sound.nix
    ../../configs/nixos/interactive-networking.nix
    ../../configs/nixos/i3
    ../../configs/nixos/sshd.nix
    ../../configs/nixos/secrets.nix
    ({
      config,
      pkgs,
      ...
    }: {
      host = {
        user = "gabe";
        fullName = "Gabe Venberg";
        gui.enable = true;
        isVm = true;
      };
      networking.hostName = "archlaptop-vm"; # Define your hostname.

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.${config.host.details.user} = {
        packages = with pkgs; [firefox];
      };

      home-manager.sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
      ];
      home-manager.users.${config.host.details.user} = {
        inputs,
        osConfig,
        lib,
        ...
      }: {
        host = osConfig.host;
        user = {
          git = {
            profile = {
              name = config.host.details.fullName;
              email = "gabevenberg@gmail.com";
            };
            workProfile.enable = false;
          };
        };
        imports = [
          ../../roles/home-manager/terminal.nix
          ../../configs/home-manager/common.nix
          ../../configs/home-manager/email.nix
          ../../configs/home-manager/tiny-irc.nix
          inputs.nixvim.homeManagerModules.nixvim
          ../../configs/home-manager/secrets.nix
        ];

        sops = lib.mkIf (inputs ? nix-secrets) {
          secrets = {
            gmail-password.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
            irc-cert.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
          };
        };
      };

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

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
      system.stateVersion = "23.11"; # Did you read the comment?
    })
  ];
}
