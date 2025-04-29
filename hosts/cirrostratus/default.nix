{
  inputs,
  myLib,
  ...
}:
# Karp site server.
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs myLib;};
  # > Our main nixos configuration file <
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    inputs.copyparty.nixosModules.default
    ./disk-config.nix
    ./hardware-configuration.nix
    ./restic.nix
    ./nginx.nix
    ./copyparty.nix
    ./deluge.nix
    ../../configs/nixos/common.nix
    ../../configs/nixos/tailscale.nix
    ../../configs/nixos/sshd.nix
    ../../configs/nixos/secrets.nix
    ../../configs/nixos/jellyfin.nix
    ../../configs/nixos/syncthing.nix
    ../../configs/nixos/grocy.nix
    ../../configs/nixos/factorio-docker.nix
    ../../configs/nixos/cyberchef.nix
    ../../configs/nixos/miniserve-directory.nix
    ../../configs/nixos/miniserve-tmp-upload.nix
    ../../configs/nixos/minecraft-docker.nix
    ../../configs/nixos/nginx-static.nix
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
      };
      boot.zfs.extraPools = ["storage"];
      networking.hostName = "cirrostratus"; # Define your hostname.
      networking.hostId = "1b9da0b9";
      networking.useNetworkd = true;
      systemd.network = {
        enable = true;
        networks."eno1" = {
          name = "eno1";
          # DHCP = "yes";
          address = ["10.10.10.30/24"];
          gateway = ["10.10.10.1"];
          dns = ["1.1.1.1"];
        };
      };
      time.timeZone = "America/Chicago";

      services.duckdns = lib.mkIf (lib.hasAttrByPath ["sops" "secrets" "duckdns-token"] config) {
        enable = true;
        domains = ["venberg"];
        tokenFile = config.sops.secrets.duckdns-token.path;
      };

      sops = lib.mkIf (inputs ? nix-secrets) {
        secrets = {
          duckdns-token.sopsFile = "${inputs.nix-secrets}/duckdns.yaml";
        };
      };

      services.tailscale.useRoutingFeatures = "server";

      # virtualisation.docker.daemon.settings.data-root="/storage/docker";

      home-manager.users.${config.host.details.user} = {
        inputs,
        osConfig,
        lib,
        ...
      }: {
        host.details = osConfig.host.details;
        user = {
          nvim.enable-lsp = false;
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
          inputs.nixvim.homeManagerModules.nixvim
        ];
      };
      boot = {
        # Bootloader.
        # loader.grub.enable = true;
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;
        supportedFilesystems.zfs = true;
        initrd.supportedFilesystems.zfs = true;
      };

      hardware.amdgpu.initrd.enable = true;
      hardware.graphics.enable = true;

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
