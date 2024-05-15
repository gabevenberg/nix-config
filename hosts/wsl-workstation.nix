{
  inputs,
  outputs,
}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs outputs;};
  # > Our main nixos configuration file <
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-wsl.nixosModules.default
    ../../modules/hostopts.nix
    ../../modules/nixos/common.nix
    ({
      config,
      pkgs,
      ...
    }: {
      wsl.enable=true;
      host = {
        user = "gabe";
      };
      networking.hostName = "workstation-vm"; # Define your hostname.
      # Set your time zone.
      time.timeZone = "America/Chicago";

      programs.zsh.enable=true;
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
          ../../roles/home-manager/terminal.nix
          ../../modules/home-manager/common.nix
          inputs.nixvim.homeManagerModules.nixvim
        ];
      };

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";
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
