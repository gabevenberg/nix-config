{
  inputs,
  myLib,
  ...
}:
(inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {inherit inputs myLib;};
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.raspberry-pi-3

    ../configs/nixos/common.nix
    ../configs/nixos/sshd.nix
    ../configs/nixos/tailscale.nix
    # ../configs/nixos/secrets.nix
    ../configs/nixos/tailscale.nix
    ({
      config,
      pkgs,
      lib,
      modulesPath,
      ...
    }: {
      imports = ["${modulesPath}/installer/sd-card/sd-image-aarch64.nix"];
      nixpkgs.hostPlatform ="aarch64-linux";
      hardware.enableRedistributableFirmware = true;
      host.details = {
        user = "gabe";
        fullName = "Gabe Venberg";
      };
      networking.hostName = "nixpi"; # Define your hostname.
      networking.useNetworkd = true;
      systemd.network = {
        enable = true;
        networks."eth0" = {
          name = "eth0";
          DHCP = "yes";
          # address = ["TODO"];
          # gateway = ["TODO"];
          # dns = ["1.1.1.1"];
        };
      };
      fileSystems = {
        "/" = {
          device = "/dev/disk/by-label/NIXOS_SD";
          fsType = "ext4";
          options = ["noatime"];
        };
      };

      time.timeZone = "America/Chicago";

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
            workProfile.enable = false;
          };
        };
        imports = [
          ../roles/home-manager/minimal-terminal.nix
          ../configs/home-manager/common.nix
          # ../configs/home-manager/secrets.nix
        ];

        # sops = lib.mkIf (inputs ? nix-secrets) {
        #   secrets = {
        #   };
        # };
      };

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      boot.supportedFilesystems.zfs = lib.mkForce false;
      boot.kernelParams = [
        "console=ttyS1,115200n8"
      ];
      boot.loader.grub.enable = false;
      boot.loader.generic-extlinux-compatible.enable = true;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "24.05"; # Did you read the comment?
    })
  ];
})
.config
.system
.build
.sdImage
