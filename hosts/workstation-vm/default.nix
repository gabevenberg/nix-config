# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  outputs,
  configLib,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs outputs configLib;};
  # > Our main nixos configuration file <
  modules = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ../../roles/nixos/graphical-vm.nix
    ../../configs/nixos/printing.nix
    ../../configs/nixos/sound.nix
    ../../configs/nixos/interactive-networking.nix
    ../../configs/nixos/nfsv2.nix
    ../../configs/nixos/i3
    ../../configs/nixos/common.nix
    ../../configs/nixos/sshd.nix
    ./secrets.nix
    ({
      config,
      pkgs,
      lib,
      inputs,
      configLib,
      ...
    }: {
      host = {
        user = "gabe";
        fullName = "Gabe Venberg";
        gui.enable = true;
        isVm = true;
      };
      networking.hostName = "workstation-vm"; # Define your hostname.

      users.mutableUsers = false;
      users.users.${config.host.user} = {
        hashedPasswordFile = config.sops.secrets.gv-password.path;
        packages = with pkgs; [
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
          git = {
            profile = {
              name = "Gabe Venberg";
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

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

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
      system.stateVersion = "23.11"; # Did you read the comment?
    })
  ];
}
