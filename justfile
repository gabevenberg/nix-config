default:
    just --list

nixos target=`hostname`:
    sudo nixos-rebuild --flake .#{{target}} switch

home-manager target=(`whoami`+"@"+`hostname`):
    home-manager --flake .#{{target}} switch

check-home-manager target=(`whoami`+"@"+`hostname`):
    home-manager build --no-out-link --flake .#{{target}}

bootstrap-home-manager target=(`whoami`+"@"+`hostname`):
    nix run --extra-experimental-features "nix-command flakes" --no-write-lock-file github:nix-community/home-manager/ -- --extra-experimental-features "nix-command flakes" --flake .#{{target}} switch

format:
    nix fmt

home-gc:
    home-manager expire-generations -7days
    nix store gc

nixos-gc:
    sudo nix-collect-garbage --delete-older-than 7d
