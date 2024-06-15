# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  configLib,
  ...
}:
(inputs.nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";
  specialArgs = {inherit inputs configLib;};
  # > Our main nixos configuration file <
  modules = [
    inputs.home-manager.nixosModules.home-manager
    ../configs/nixos/interactive-networking.nix
    ../configs/nixos/common.nix
    ../configs/nixos/sshd.nix
    ../roles/nixos/power-saving.nix
    ({
      config,
      pkgs,
      lib,
      inputs,
      configLib,
      modulesPath,
      options,
      ...
    }: {
      # nixpkgs.crossSystem.system="aarch64-linux";
      nixpkgs.buildPlatform.system = "x86_64-linux";
      nixpkgs.hostPlatform.system = "aarch64-linux";
      imports = [
        # "${modulesPath}/installer/sd-card/sd-image.nix"
        "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
      ];
      host = {
        user = "gabe";
        fullName = "Gabe Venberg";
        gui.enable = true;
      };
      networking.hostName = "nixos-installer"; # Define your hostname.

      users.users.${config.host.user} = {
        packages = with pkgs; [
          gparted
          firefox
        ];
      };

      home-manager.users.${config.host.user} = {
        inputs,
        osConfig,
        ...
      }: {
        host = osConfig.host;
        user = {
          nvim.enable = false;
          git = {
            profile = {
              name = "Gabe Venberg";
              email = "gabevenberg@gmail.com";
            };
            workProfile.enable = false;
          };
        };
        imports = [
          ../roles/home-manager/minimal-terminal.nix
          ../configs/home-manager/common.nix
          inputs.nixvim.homeManagerModules.nixvim
        ];
      };

      boot.loader.grub.enable = false;
      boot.loader.generic-extlinux-compatible.enable = true;

      boot.consoleLogLevel = lib.mkDefault 7;
      boot.kernelParams = ["console=ttyS0,115200n8" "console=ttyAMA0,115200n8" "console=tty0"];

      # Adds terminus_font for people with HiDPI displays
      console.packages = options.console.packages.default ++ [pkgs.terminus_font];

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

      system.stateVersion = lib.mkDefault lib.trivial.release;
    })
  ];
})
.config
.system
.build
.sdImage
