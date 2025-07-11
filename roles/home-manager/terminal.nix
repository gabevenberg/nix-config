{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./minimal-terminal.nix
    ../../configs/home-manager/nushell
    ../../configs/home-manager/starship.nix
    ../../configs/home-manager/zk.nix
  ];

  home.packages = with pkgs; [
    tre-command
    ripgrep-all
    hyperfine
    fclones
    libqalculate
    f2
    inputs.nvim-config.packages.${pkgs.system}.nvim
  ];

  home.sessionVariables.EDITOR = "nvim";

  programs = {
    zoxide.enable = true;
    tealdeer.enable = true;
  };
}
