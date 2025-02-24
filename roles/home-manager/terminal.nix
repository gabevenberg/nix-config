{
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

  user = {
    nvim = {
      enable-lsp = lib.mkDefault true;
      enable-treesitter = lib.mkDefault true;
    };
  };

  home.packages = with pkgs; [
    tre-command
    hyperfine
    dua
    fclones
    libqalculate
  ];

  programs = {
    zoxide.enable = true;
    tealdeer.enable = true;
  };
}
