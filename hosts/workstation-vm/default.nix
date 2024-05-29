# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
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
    ./hardware-configuration.nix
    ../../roles/nixos/graphical-vm.nix
    ../../modules/hostopts.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/printing.nix
    ../../modules/both/sound.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/nfsv2.nix
    ../../modules/both/i3
    ({
      config,
      pkgs,
      lib,
      ...
    }: {
      host = {
        user = "gabe";
        gui.enable = true;
        isVm = true;
      };
      networking.hostName = "workstation-vm"; # Define your hostname.
      # Set your time zone.
      time.timeZone = "America/Chicago";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";

      # Configure keymap in X11
      services.xserver = {
        xkb.layout = "us";
        xkb.variant = "";
      };

      programs.zsh.enable = true;
      environment.shells = with pkgs; [zsh];
      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.${config.host.user} = {
        isNormalUser = true;
        description = "Gabe Venberg";
        shell = pkgs.zsh;
        extraGroups = ["wheel"];
        packages = with pkgs; [
          firefox
          #  thunderbird
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
          ../../modules/home-manager/common.nix
          inputs.nixvim.homeManagerModules.nixvim
        ];
      };
      # Enable the OpenSSH daemon.
      services.openssh.enable = true;

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
