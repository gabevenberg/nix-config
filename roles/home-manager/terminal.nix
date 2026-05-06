{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./minimal-terminal.nix
    ../../configs/home-manager/zellij
    ../../configs/home-manager/nushell
    ../../configs/home-manager/starship.nix
    ../../configs/home-manager/zk.nix
  ];

  home.packages = with pkgs; [
    ripgrep-all
    hyperfine
    fclones
    libqalculate
    f2
    clock-rs
    hexyl
    caligula
    hurl
    rgx
    #TODO! move this to graphics module? This provides a drag and drop interface from the CLI.
    dragon-drop
  ];

  wrappers.neovim.enable = true;
  wrappers.neovim.settings.minimal = false;

  home.sessionVariables.EDITOR = "nvim";

  programs = {
    zoxide.enable = true;
    tealdeer.enable = true;
  };
}
