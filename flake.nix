{
  description = "Nix config for both home-manager and nixos";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-fork.url="github:gabevenberg/nixpkgs/kicad-step-fix";
    # nixpkgs-fork.url = "git+file:///home/gabe/dev/nixpkgs";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
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

    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    #https://unmovedcentre.com/technology/2024/03/22/secrets-management.html
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #My nvim config.
    nvim-config = {
      url = "git+ssh://forgejo@git.venberg.xyz/Gabe/nvim-config.git?shallow=1";
      # url = "git+file:///home/gabe/nvim-config";
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
    myLib = import ./lib {inherit lib;};
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            just
            nixos-rebuild
            deploy-rs.packages.${system}.deploy-rs
          ];
        };
      }
    );

    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      cumulus = import ./hosts/cumulus {inherit inputs myLib;};
      cirrus = import ./hosts/cirrus {inherit inputs myLib;};
      cirrostratus = import ./hosts/cirrostratus {inherit inputs myLib;};
      altostratus = import ./hosts/altostratus {inherit inputs myLib;};
      harmatan = import ./hosts/harmatan {inherit inputs myLib;};
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "gabe@linuxgamingrig" = import ./hosts/home-personal.nix {inherit inputs myLib;};
      "gabe@gvworklaptop" = import ./hosts/work-laptop.nix {inherit inputs myLib;};
    };

    deploy = {
      nodes = {
        cumulus = {
          hostname = "cumulus";
          profiles.system.path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.cumulus;
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
        altostratus = {
          hostname = "altostratus";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.altostratus;
        };
        harmatan = {
          hostname = "harmatan";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.harmatan;
        };
      };
      sshUser = "root";
    };

    packages.x86_64-linux = {
      proxmox = import ./packages/proxmox.nix {inherit inputs myLib;};
      iso = import ./packages/iso.nix {inherit inputs myLib;};
      aarch-64-iso = import ./packages/aarch64-iso.nix {inherit inputs myLib;};
      rpi3-sd-image = import ./packages/rpi3-sd-image.nix {inherit inputs myLib;};
    };

    templates = import ./templates;
  };
}
