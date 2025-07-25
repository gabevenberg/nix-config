{
  inputs,
  myLib,
  ...
}:
(inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs myLib;};
  # > Our main nixos configuration file <
  modules = [
    inputs.home-manager.nixosModules.home-manager
    ../configs/nixos/printing.nix
    ../configs/nixos/sound.nix
    ../configs/nixos/interactive-networking.nix
    ../configs/nixos/i3
    ../configs/nixos/common.nix
    ../configs/nixos/sshd.nix
    ../configs/nixos/tailscale.nix
    ../roles/nixos/power-saving.nix
    ({
      config,
      pkgs,
      lib,
      inputs,
      modulesPath,
      options,
      ...
    }: {
      imports = [
        "${modulesPath}/installer/cd-dvd/iso-image.nix"
        "${modulesPath}/profiles/base.nix"
        "${modulesPath}/profiles/clone-config.nix"
        "${modulesPath}/profiles/qemu-guest.nix"
        "${modulesPath}/profiles/all-hardware.nix"
        "${modulesPath}/installer/scan/detected.nix"
        "${modulesPath}/installer/scan/not-detected.nix"
      ];
      host.details = {
        user = "gabe";
        fullName = "Gabe Venberg";
        gui.enable = true;
      };
      networking.hostName = "nixos-installer"; # Define your hostname.

      users.users.${config.host.details.user} = {
        packages = with pkgs; [
          firefox
          gptfdisk
        ];
      };

      home-manager.users.${config.host.details.user} = {
        inputs,
        osConfig,
        ...
      }: {
        host.details = osConfig.host.details;
        user = {
          git = {
            profile = {
              name = "Gabe Venberg";
              email = "gabevenberg@gmail.com";
            };
            workProfile.enable = false;
          };
        };
        imports = [
          ../roles/home-manager/terminal.nix
          ../configs/home-manager/common.nix
        ];
      };

      # Adds terminus_font for people with HiDPI displays
      console.packages = options.console.packages.default ++ [pkgs.terminus_font];

      # ISO naming.
      isoImage.isoName = "${config.isoImage.isoBaseName}-${pkgs.stdenv.hostPlatform.system}.iso";

      # EFI booting
      isoImage.makeEfiBootable = true;

      # USB booting
      isoImage.makeUsbBootable = true;

      # Add Memtest86+ to the CD.
      boot.loader.grub.memtest86.enable = true;

      # services.libinput.enable = true; # for touchpad support on many laptops

      # An installation media cannot tolerate a host config defined file
      # system layout on a fresh machine, before it has been formatted.
      swapDevices = lib.mkForce [];
      fileSystems = lib.mkForce config.lib.isoFileSystems;

      system.nixos.variant_id = lib.mkDefault "installer";

      # Enable in installer, even if the minimal profile disables it.
      documentation.enable = lib.mkForce true;

      # Show the manual.
      documentation.nixos.enable = lib.mkForce true;

      # Tell the Nix evaluator to garbage collect more aggressively.
      # This is desirable in memory-constrained environments that don't
      # (yet) have swap set up.
      environment.variables.GC_INITIAL_HEAP_SIZE = "1M";

      # Make the installer more likely to succeed in low memory
      # environments.  The kernel's overcommit heustistics bite us
      # fairly often, preventing processes such as nix-worker or
      # download-using-manifests.pl from forking even if there is
      # plenty of free memory.
      boot.kernel.sysctl."vm.overcommit_memory" = "1";

      # To speed up installation a little bit, include the complete
      # stdenv in the Nix store on the CD.
      system.extraDependencies = with pkgs; [
        stdenv
        stdenvNoCC # for runCommand
        busybox
        jq # for closureInfo
        # For boot.initrd.systemd
        makeInitrdNGTool
      ];

      # Show all debug messages from the kernel but don't log refused packets
      # because we have the firewall enabled. This makes installs from the
      # console less cumbersome if the machine has a public IP.
      networking.firewall.logRefusedConnections = lib.mkDefault false;

      # Prevent installation media from evacuating persistent storage, as their
      # var directory is not persistent and it would thus result in deletion of
      # those entries.
      environment.etc."systemd/pstore.conf".text = ''
        [PStore]
        Unlink=no
      '';

      # Much faster than xz
      isoImage.squashfsCompression = lib.mkDefault "zstd";

      system.stateVersion = lib.mkDefault lib.trivial.release;
    })
  ];
})
.config
.system
.build
.isoImage
