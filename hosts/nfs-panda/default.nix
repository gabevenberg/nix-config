{
  inputs,
  outputs,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs outputs;};
  # > Our main nixos configuration file <
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    ../../modules/hostopts.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/nfsv2.nix
    ({
      config,
      pkgs,
      ...
    }: {
      host = {
        user = "gabe";
        gui.enable = false;
      };
      networking.hostId = "4dabfd52";
      # Define your hostname.
      networking.hostName = "gv-panda";
      systemd.network = {
        enable = true;
        networks = {
          enp2s0 = {
            name = "enp2s0";
            address = [
              "172.16.0.20/16"
              "192.168.168.20/24"
            ];
          };
          enx00249b6f0f57 = {
            name = "enx00249b6f0f57";
            DHCP = "yes";
          };
        };
      };

      time.timeZone = "America/Chicago";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";

      services.nfs.server = {
        enable = true;
        exports = "/srv/nfs *(rw,sync,no_root_squash)";
        createMountPoints = true;
      };

      environment.systemPackages = with pkgs; [
        zfs
        neovim
      ];

      programs.zsh.enable = true;
      environment.shells = with pkgs; [zsh];
      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.${config.host.user} = {
        isNormalUser = true;
        description = "Gabe Venberg";
        shell = pkgs.zsh;
        extraGroups = ["wheel"];
      };

      home-manager.users.${config.host.user} = {
        inputs,
        osConfig,
        ...
      }: {
        host = osConfig.host;
        # machine specific options
        home = {
          nvim = {
            enable-lsp = false;
            enable-treesitter = false;
          };
          git = {
            profile = {
              name = "Gabe Venberg";
              email = "gabevenberg@gmail.com";
            };
            workProfile = {
              enable = true;
              email = "venberggabe@johndeere.com";
            };
          };
        };
        imports = [
          ../../roles/home-manager/terminal.nix
          ../../modules/home-manager/common.nix
          inputs.nixvim.homeManagerModules.nixvim
        ];
      };

      # Enable the OpenSSH daemon.
      services.openssh.enable = true;

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
      boot.supportedFilesystems = {zfs = true;};
      boot.initrd.supportedFilesystems = {zfs = true;};

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "23.11"; # Did you read the comment?
    })
  ];
}
