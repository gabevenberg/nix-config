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
    ./disk-config.nix
    ./hardware-config.nix
    ../../configs/nixos/common.nix
    ../../configs/nixos/sshd.nix
    ../../configs/nixos/interactive-networking.nix
    ../../configs/nixos/secrets.nix
    ../../configs/nixos/tailscale.nix
    ../../configs/nixos/printing.nix
    ../../configs/nixos/syncthing.nix
    ../../configs/nixos/touchpad.nix
    ../../configs/nixos/i3
    ../../configs/nixos/bluetooth.nix
    ../../roles/nixos/gaming.nix
    ../../roles/nixos/power-saving.nix
    ../../roles/nixos/embedded-dev
    ({
      config,
      pkgs,
      lib,
      ...
    }: {
      nixpkgs.hostPlatform ="x86_64-linux";
      host.details = {
        user = "gabe";
        fullName = "Gabe Venberg";
        gui.enable = true;
        isLaptop = true;
      };
      networking.hostName = "harmatan";
      networking.hostId = "7a42af26";

      services.displayManager.defaultSession = "i3";
      services.xserver.dpi = 210;
      environment.variables = {
        GDK_SCALE = "2";
        GDK_DPI_SCALE = "0.5";
      };

      nixpkgs.overlays = let
        args = "--force-device-scale-factor=2";
        desktopItemModifier = prevAttrs: {
          desktopItem = prevAttrs.desktopItem.override (prev: {
            exec = "${prev.exec} ${args}";
          });
        };
        desktopItemsModifier = previousAttrs: {
          desktopItems = [
            ((builtins.head previousAttrs.desktopItems).override (prev: {
              exec = "${prev.exec} ${args}";
            }))
          ];
        };
      in [
        (final: prev: {
          discord = prev.discord.overrideAttrs desktopItemModifier;
          signal-desktop = prev.signal-desktop.overrideAttrs desktopItemsModifier;
        })
      ];

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
          };
        };
        home.packages = with pkgs; [
          signal-desktop
        ];

        home.file.".config/electron-flags.conf".text = ''
          --force-device-scale-factor=2
        '';
        imports = [
          ../../roles/home-manager/terminal.nix
          ../../roles/home-manager/music.nix
          ../../roles/home-manager/3dprinting.nix
          ../../configs/home-manager/common.nix
          ../../configs/home-manager/secrets.nix
          ../../configs/home-manager/email.nix
          ../../configs/home-manager/tiny-irc.nix
          ../../configs/home-manager/senpai-irc.nix
          ../../configs/home-manager/halloy-irc.nix
          ../../configs/home-manager/kicad.nix
        ];

        sops = lib.mkIf (inputs ? nix-secrets) {
          secrets = {
            gmail-password.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
            irc-cert.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
            soju-password.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
          };
        };
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
