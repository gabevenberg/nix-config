{
  description = "Nix config for both home-manager and nixos";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };

    #https://unmovedcentre.com/technology/2024/03/22/secrets-management.html
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-secrets = {
      url = "git+ssh://forgejo@git.venberg.xyz/Gabe/nix-secrets.git?shallow=1";
      # url = "git+https://git.venberg.xyz/Gabe/nix-secrets.git?shallow=1";
      flake = false;
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # just for follows statements
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
  };

  outputs = {
    self,
    nixpkgs,
    deploy-rs,
    ...
  } @ inputs: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ];
    inherit (nixpkgs) lib;
    configLib = import ./lib {inherit lib;};
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            just
            deploy-rs.packages.${system}.deploy-rs
          ];
        };
      }
    );

    lib = configLib;

    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      rockhole = import ./hosts/rockhole64 {inherit inputs configLib;};
      cirrus = import ./hosts/cirrus {inherit inputs configLib;};
      cirrostratus = import ./hosts/cirrostratus {inherit inputs configLib;};
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "gabe@archlaptop" = import ./hosts/home-laptop.nix {inherit inputs configLib;};
      "gabe@linuxgamingrig" = import ./hosts/home-personal.nix {inherit inputs configLib;};
      "gabe@gvworklaptop" = import ./hosts/work-laptop.nix {inherit inputs configLib;};
    };

    deploy = {
      nodes = {
        rockhole = {
          hostname = "rockpro";
          profiles.system.path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.rockhole;
          remoteBuild = true;
        };
        cirrus = {
          hostname = "cirrus";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.cirrus;
        };
        cirrostratus = {
          hostname = "cirrostratus";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.cirrostratus;
          remoteBuild = true;
        };
      };
      sshUser = "root";
    };

    packages.x86_64-linux = {
      proxmox = import ./packages/proxmox.nix {inherit inputs configLib;};
      iso = import ./packages/iso.nix {inherit inputs configLib;};
      aarch-64-iso = import ./packages/aarch64-iso.nix {inherit inputs configLib;};
      rpi3-sd-image = import ./packages/rpi3-sd-image.nix {inherit inputs configLib;};
    };

    templates = import ./templates;
  };
}
