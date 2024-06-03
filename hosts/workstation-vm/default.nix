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

      users.users.root.openssh.authorizedKeys.keys =
        configLib.dirToStrings "${inputs.nix-secrets}/public-keys";

      programs.zsh.enable = true;
      environment.shells = with pkgs; [zsh];
      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.mutableUsers = false;
      users.users.${config.host.user} = {
        hashedPasswordFile = config.sops.secrets.gv-password.path;
        isNormalUser = true;
        description = "Gabe Venberg";
        shell = pkgs.zsh;
        extraGroups = ["wheel"];
        packages = with pkgs; [
          firefox
          #  thunderbird
        ];
        openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
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
