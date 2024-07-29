{
  inputs,
  configLib,
  ...
}:
# Hetzner cloud multipurpouse server
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs configLib;};
  # > Our main nixos configuration file <
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    ./nginx.nix
    ../../roles/nixos/vm.nix
    ../../configs/nixos/common.nix
    ../../configs/nixos/tailscale.nix
    ../../configs/nixos/sshd.nix
    ../../configs/nixos/secrets.nix
    ../../configs/nixos/radicale.nix
    # ../../configs/nixos/forgejo.nix
    ({
      config,
      pkgs,
      configLib,
      ...
    }: {
      host = {
        user = "gabe";
        fullName = "Gabe Venberg";
        gui.enable = false;
        isVm = true;
      };
      networking.hostName = "cirrus"; # Define your hostname.
      networking.hostId = "908b80b6";
      networking.useNetworkd = true;
      systemd.network = {
        enable = true;
        networks."enp1s0" = {
          networkConfig.DHCP = "ipv4";
          gateway = ["fe80::1"];
          address = ["2a01:4f8:1c1b:6c7c::1/64"];
        };
      };

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
        ];
      };

      # Bootloader.
      # boot.loader.systemd-boot.enable = true;
      boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];

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
      system.stateVersion = "24.05"; # Did you read the comment?
    })
  ];
}
