{
  inputs,
  myLib,
  ...
}:
# Hetzner cloud multipurpouse server
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs myLib;};
  # > Our main nixos configuration file <
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    ./nginx.nix
    ./restic.nix
    ../../roles/nixos/vm.nix
    ../../configs/nixos/common.nix
    ../../configs/nixos/tailscale.nix
    ../../configs/nixos/sshd.nix
    ../../configs/nixos/secrets.nix
    ../../configs/nixos/radicale.nix
    ../../configs/nixos/forgejo.nix
    ../../configs/nixos/homepage.nix
    ../../configs/nixos/freshrss.nix
    ({
      config,
      pkgs,
      lib,
      ...
    }: {
      host.details = {
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

      sops = lib.mkIf (inputs ? nix-secrets) {
        secrets = {
          radicale-users = {
            sopsFile = "${inputs.nix-secrets}/radicale-users";
            format = "binary";
            owner = "radicale";
          };
          gabevenberg-draft-credentials = {
            sopsFile = "${inputs.nix-secrets}/draft.gabevenberg.com";
            format = "binary";
            owner = config.services.nginx.user;
          };
          freshrss-password = {
            sopsFile = "${inputs.nix-secrets}/freshrss.yaml";
            owner = config.services.freshrss.user;
          };
        };
      };
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
          ../../roles/home-manager/minimal-terminal.nix
          ../../configs/home-manager/common.nix
        ];
      };

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
