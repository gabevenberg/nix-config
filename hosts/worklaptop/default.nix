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
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s
    ./disk-config.nix
    ./hardware-configuration.nix
    ../../configs/nixos/common.nix
    ../../configs/nixos/tailscale.nix
    ../../configs/nixos/sshd.nix
    ../../configs/nixos/secrets.nix
    ../../configs/nixos/i3
    ../../configs/nixos/sound.nix
    ../../configs/nixos/printing.nix
    ../../configs/nixos/touchpad.nix
    ../../configs/nixos/syncthing.nix
    ../../configs/nixos/interactive-networking.nix
    ../../roles/nixos/power-saving.nix
    ({
      config,
      pkgs,
      configLib,
      lib,
      ...
    }: {
      host = {
        user = "gabe";
        fullName = "Gabe Venberg";
        gui.enable = false;
        isVm = true;
      };
      networking.hostName = "gvenbergworklaptop"; # Define your hostname.
      networking.hostId = "ab8aa83e";

      home-manager.sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
      ];

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
            workProfile.enable = true;
            workProfile.email = "gabriel.venberg@assistme.io";
          };
        };
        sops = lib.mkIf (inputs ? nix-secrets) {
          secrets = {
            gmail-password.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
            irc-cert.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
          };
        };
        imports = [
          ../../roles/home-manager/terminal.nix
          ../../configs/home-manager/common.nix
          ../../configs/home-manager/secrets.nix
          ../../roles/home-manager/music.nix
          ../../configs/home-manager/email.nix
          ../../configs/home-manager/tiny-irc.nix
          inputs.nixvim.homeManagerModules.nixvim
        ];
      };

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      hardware.enableRedistributableFirmware = true;

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
