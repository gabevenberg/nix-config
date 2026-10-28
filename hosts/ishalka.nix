# work mac.
{
  inputs,
  myLib,
  ...
}:
inputs.nix-darwin.lib.darwinSystem {
  specialArgs = {inherit inputs myLib;};
  modules =
    [
      inputs.home-manager.darwinModules.home-manager
      ../configs/darwin/common.nix
      ../configs/darwin/tailscale.nix
      ({
        config,
        pkgs,
        ...
      }: {
        nixpkgs.hostPlatform = "aarch64-darwin";
        host.details = {
          user = "gabriel.venberg-ext";
          fullName = "Gabe Venberg";
          gui.enable = true;
          isLaptop = true;
        };
        networking = {
          hostName = "ishalka";
          computerName = "ishalka";
          localHostName = "ishalka";
        };

        home-manager.sharedModules = [inputs.sops-nix.homeManagerModules.sops];
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
              workProfile = {
                enable = true;
                email = "gabriel.venberg-ext@man.eu";
              };
            };
          };

          programs.firefox.enable=true;

          imports = [
            ../roles/home-manager/terminal.nix
            ../roles/home-manager/all_the_langs.nix
            ../configs/home-manager/common.nix
            ../configs/home-manager/secrets.nix
            ../configs/home-manager/senpai-irc.nix
            ../configs/home-manager/kitty.nix
            ../configs/home-manager/aerospace.nix
          ];

          sops = lib.mkIf (inputs ? nix-secrets) {
            secrets = {
              # TODO: add this machines key to nix-secrets.
              # soju-password.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
            };
          };
        };

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 6;
      })
    ]
    ++ (inputs.nixpkgs.lib.optional (inputs ? nix-secrets) "${toString inputs.nix-secrets}/nix/hosts/ishalka.nix");
}
