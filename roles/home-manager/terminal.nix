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

  user.nvim = {
    enable-lsp = true;
    enable-treesitter = true;
  };

  home.packages = with pkgs; [
    tre-command
    diskonaut
    hyperfine
  ];

  home.sessionVariables = {
    PIPENV_VENV_IN_PROJECT = 1;
    POETRY_VIRTUALENVS_IN_PROJECT = 1;
  };

  programs = {
    zoxide.enable = true;
    tealdeer.enable = true;
  };
}
