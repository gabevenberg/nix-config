{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    treefmt-nix,
    ...
  }: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ] (system:
        function {
          pkgs = import nixpkgs {inherit system;};
          inherit system;
        });

    treefmtEval = forAllSystems ({pkgs, ...}: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
  in {
    formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);
    devShells.default = forAllSystems ({pkgs, ...}:
      pkgs.mkShell {
        buildInputs = with pkgs; [
          typst
        ];
      });
  };
}
