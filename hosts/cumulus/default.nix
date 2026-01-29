{
  inputs,
  myLib,
  ...
}:
# rockpro64 home arm64 server, serves as adblocker among other things.
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {inherit inputs myLib;};
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    ./hardware-config.nix
    ./adguard.nix
    ./nginx.nix
    ../../configs/nixos/common.nix
    ../../configs/nixos/sshd.nix
    ../../configs/nixos/secrets.nix
    ../../configs/nixos/tailscale.nix
    ({
      config,
      pkgs,
      lib,
      ...
    }: {
      boot.initrd.kernelModules = [
        # PCIe/NVMe
        "nvme"
        "pcie_rockchip_host"
        "rockchip_rga"
        "rockchip_saradc"
        "rockchip_thermal"
        "rockchipdrm"
        "phy_rockchip_pcie"
      ];
      nixpkgs.hostPlatform = "aarch64-linux";
      hardware.enableRedistributableFirmware = true;
      host.details = {
        user = "gabe";
        fullName = "Gabe Venberg";
        gui.enable = false;
      };
      networking.hostName = "cumulus"; # Define your hostname.
      networking.hostId = "e0c31928";
      networking.useNetworkd = true;
      systemd.network = {
        enable = true;
        networks."0-end0" = {
          name = "end0";
          address = ["10.10.0.2/16"];
          gateway = ["10.10.0.1"];
          dns = ["1.1.1.1"];
        };
      };

      services.duckdns = lib.mkIf (lib.hasAttrByPath ["sops" "secrets" "duckdns-token"] config) {
        enable = true;
        domains = ["gabevenberg"];
        tokenFile = config.sops.secrets.duckdns-token.path;
      };

      sops = lib.mkIf (inputs ? nix-secrets) {
        secrets = {
          duckdns-token.sopsFile = "${inputs.nix-secrets}/duckdns.yaml";
        };
      };

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
      system.stateVersion = "24.05"; # Did you read the comment?
    })
  ];
}
