{
  inputs,
  configLib,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";
  specialArgs = {inherit inputs configLib;};
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.raspberry-pi-3
    ../../configs/nixos/common.nix
    ../../configs/nixos/sshd.nix
    ../../configs/nixos/secrets.nix
    ../../configs/nixos/tailscale.nix
    ({
      config,
      pkgs,
      lib,
      configLib,
      ...
    }: {
      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "usbhid"
        "usb_storage"
      ];
      hardware.enableRedistributableFirmware = true;
      host = {
        user = "gabe";
        fullName = "Gabe Venberg";
      };
      networking.hostName = "remotepi"; # Define your hostname.
      networking.hostId = "8efd3e13";
      networking.useNetworkd = true;
      systemd.network = {
        enable = true;
        networks."TODO" = {
          name = "TODO";
          address = ["TODO"];
          gateway = ["TODO"];
          dns = ["1.1.1.1"];
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
      home-manager.users.${config.host.user} = {
        inputs,
        osConfig,
        lib,
        ...
      }: {
        host = osConfig.host;
        user = {
          git = {
            profile = {
              name = config.host.fullName;
              email = "gabevenberg@gmail.com";
            };
            workProfile.enable = false;
          };
        };
        imports = [
          ../../roles/home-manager/minimal-terminal.nix
          ../../configs/home-manager/common.nix
          inputs.nixvim.homeManagerModules.nixvim
          # ../../configs/home-manager/secrets.nix
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

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "24.11"; # Did you read the comment?
    })
  ];
}