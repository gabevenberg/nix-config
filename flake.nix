{
  description = "Nix config for both home-manager and nixos";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.home-manager.follows = "home-manager";
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

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #https://unmovedcentre.com/technology/2024/03/22/secrets-management.html
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-secrets = {
      url = "git+ssh://git@git.venberg.xyz:7920/Gabe/nix-secrets.git?shallow=1";
      # url = "git+https://git.venberg.xyz/Gabe/nix-secrets.git?shallow=1";
      flake = false;
    };

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
    inherit (self) outputs;
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
      archlaptop-vm = import ./hosts/archlaptop-vm {inherit inputs outputs configLib;};
      workstation-vm = import ./hosts/workstation-vm {inherit inputs outputs configLib;};
      gv-wsl = import ./hosts/wsl-workstation.nix {inherit inputs outputs configLib;};
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "gabe@archlaptop" = import ./hosts/home-personal.nix {inherit inputs outputs configLib;};
      "gabe@linuxgamingrig" = import ./hosts/home-personal.nix {inherit inputs outputs configLib;};
      "gabe@gv-workstation" = import ./hosts/home-workstation.nix {inherit inputs outputs configLib;};
      "gabe@gv-ubuntu" = import ./hosts/home-workstation.nix {inherit inputs outputs configLib;};
    };

    packages.x86_64-linux.proxmox = import ./packages/proxmox.nix {inherit inputs outputs configLib;};

    templates = import ./templates {inherit inputs outputs;};
  };
}
