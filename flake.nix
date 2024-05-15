{
  description = "Nix config for both home-manager and nixos";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixvim,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ];
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            just
          ];
        };
      }
    );

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      archlaptop-vm = import ./hosts/archlaptop-vm {inherit inputs outputs;};
      workstation-vm = import ./hosts/workstation-vm {inherit inputs outputs;};
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "gabe@archlaptop" = import ./hosts/home-personal.nix {inherit inputs outputs;};
      "gabe@linuxgamingrig" = import ./hosts/home-personal.nix {inherit inputs outputs;};
      "gabe@gv-workstation" = import ./hosts/home-workstation.nix {inherit inputs outputs;};
    };
  };
}
