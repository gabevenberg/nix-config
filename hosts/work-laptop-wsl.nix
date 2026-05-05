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
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga402x-amdgpu
    inputs.nixos-wsl.nixosModules.default
    ../configs/nixos/common.nix
    ../configs/nixos/sshd.nix
    ../configs/nixos/secrets.nix
    ../configs/nixos/syncthing.nix
    ../roles/nixos/embedded-dev
    ({
      config,
      pkgs,
      lib,
      ...
    }: {
      nixpkgs.hostPlatform = "x86_64-linux";
      host.details = {
        user = "gabe";
        fullName = "Gabe Venberg";
        gui.enable = true;
        isLaptop = true;
      };
      networking.hostName = "worklaptop";

      wsl.enable = true;
      wsl.defaultUser = config.host.details.user;

      home-manager.sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
      ];
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
              email = "gabriel.venberg@maibornwolff.de";
            };
          };
        };

        home.packages = with pkgs; [
        ];

        imports = [
          ../roles/home-manager/terminal.nix
          ../roles/home-manager/all_the_langs.nix
          ../configs/home-manager/common.nix
          ../configs/home-manager/secrets.nix
          ../configs/home-manager/email.nix
          ../configs/home-manager/senpai-irc.nix
        ];

        sops = lib.mkIf (inputs ? nix-secrets) {
          secrets = {
            gmail-password.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
            irc-cert.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
            soju-password.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
          };
        };
      };

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.11"; # Did you read the comment?
    })
  ];
}
