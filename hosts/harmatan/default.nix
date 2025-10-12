{
  inputs,
  myLib,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs myLib;};
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga402x-amdgpu
    ./disk-config.nix
    ./hardware-config.nix
    ../../configs/nixos/common.nix
    ../../configs/nixos/sshd.nix
    # TODO
    #../../configs/nixos/secrets.nix
    ../../configs/nixos/tailscale.nix
    ../../configs/nixos/printing.nix
    ../../configs/nixos/syncthing.nix
    ../../configs/nixos/touchpad.nix
    ../../configs/nixos/i3
    ({
      config,
      pkgs,
      lib,
      ...
    }: {
      host.details = {
        user = "gabe";
        fullName = "Gabe Venberg";
        gui.enable = true;
        isLaptop = true;
      };
      networking.hostName = "harmatan";
      networking.hostId = "7a42af26";

      # TODO
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
          };
        };
        imports = [
          ../../roles/home-manager/terminal.nix
          ../../roles/home-manager/music.nix
          ../../configs/home-manager/common.nix
          # TODO
          # ../../configs/home-manager/secrets.nix
          ../configs/home-manager/email.nix
          ../configs/home-manager/tiny-irc.nix
        ];

        # TODO
        # sops = lib.mkIf (inputs ? nix-secrets) {
        #   secrets = {
        #     gmail-password.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
        #     irc-cert.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
        #   };
        # };
      };

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = false;

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
