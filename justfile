default:
    just --list

home-manager target:
    home-manager --flake .#{{target}} switch

check-home-manager target:
    home-manager build --no-out-link --flake .#{{target}}

bootstrap-home-manager target:
    nix run --extra-experimental-features "nix-command flakes" --no-write-lock-file github:nix-community/home-manager/ -- --extra-experimental-features "nix-command flakes" --flake .#{{target}} switch

format:
    nix fmt

home-gc:
    home-manager expire-generations -7days
    nix store gc
