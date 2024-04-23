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
    ../../modules/hostopts.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/printing.nix
    ../../modules/both/sound.nix
    ../../modules/both/networking.nix
    ../../modules/both/i3
    ({
      config,
      pkgs,
      ...
    }: {
      host = {
        user = "gabe";
        gui.enable = true;
        isVm = true;
      };
      networking.hostName = "archlaptop-vm"; # Define your hostname.
      # Set your time zone.
      time.timeZone = "America/Chicago";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      # Configure keymap in X11
      services.xserver = {
        xkb.layout = "us";
        xkb.variant = "";
      };

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.${config.host.user} = {
        isNormalUser = true;
        description = "Gabe Venberg";
        shell = pkgs.nushell;
        extraGroups = ["wheel"];
        packages = with pkgs; [
          firefox
          #  thunderbird
        ];
      };

      home-manager.users.${config.host.user} = {inputs, osConfig, ...}: {
        host=osConfig.host;
        home = {
          enable-speech = true;
          nvim = {
            enable-lsp = true;
            enable-treesitter = true;
          };
          git = {
            profile = {
              name = "Gabe Venberg";
              email = "gabevenberg@gmail.com";
            };
            workProfile.enable = false;
          };
        };
        imports = [
          ../../modules/home-manager/terminal
          ../../modules/home-manager/nvim
          ../../modules/home-manager
          ../modules/home-manager/email.nix
          inputs.nixvim.homeManagerModules.nixvim
        ];
      };
      # Enable the OpenSSH daemon.
      services.openssh.enable = true;

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

      # Enable the X11 windowing system.
      # services.xserver.enable = true;
      #
      # # Enable the Cinnamon Desktop Environment.
      # services.xserver.displayManager.lightdm.enable = true;
      # services.xserver.desktopManager.cinnamon.enable = true;
    })
  ];
}
