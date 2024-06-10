{
  inputs,
  configLib,
}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs configLib;};
  # > Our main nixos configuration file <
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-wsl.nixosModules.default
    ../configs/nixos/common.nix
    ({
      config,
      pkgs,
      configLib,
      ...
    }: {
      wsl.enable = true;
      wsl.wslConf.network.generateResolvConf = false;
      networking.nameservers = ["1.1.1.1" "8.8.8.8"];
      host = {
        user = "nixos";
        fullName = "Gabe Venberg";
      };
      networking.hostName = "gv-wsl"; # Define your hostname.

      home-manager.users.${config.host.user} = {
        inputs,
        osConfig,
        ...
      }: {
        host = osConfig.host;
        user = {
          nvim = {
            enable-lsp = true;
            enable-treesitter = true;
          };
          git = {
            profile = {
              name = config.host.fullName;
              email = "gabevenberg@gmail.com";
            };
            workProfile.enable = false;
          };
        };
        imports = [
          ../roles/home-manager/terminal.nix
          ../configs/home-manager/common.nix
          inputs.nixvim.homeManagerModules.nixvim
        ];
      };

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
