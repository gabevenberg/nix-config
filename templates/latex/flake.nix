{
  description = "basic devshell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ] (system:
        function {
          pkgs = import nixpkgs {inherit system;};
          inherit system;
        });
  in {
    devShells = forAllSystems ({pkgs, ...}: {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          texliveFull
          just
        ];
      };
    });
  };
}
