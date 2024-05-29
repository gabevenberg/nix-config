{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./minimal-terminal.nix
    ../../modules/home-manager/terminal/nushell
    ../../modules/home-manager/terminal/starship.nix
    ../../modules/home-manager/terminal/tiny-irc.nix
  ];

  user = {
    nushell.enable = true;
    starship.enable = true;
    tiny.enable = true;
    nvim = {
      enable-lsp = true;
      enable-treesitter = true;
    };
  };

  home.packages = with pkgs; [
    tre-command
    diskonaut
    hyperfine
  ];

  programs = {
    zoxide.enable = true;
    tealdeer.enable = true;
  };
}
