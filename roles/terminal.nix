{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./minimal-terminal.nix
    ../modules/home-manager/terminal/nushell
    ../modules/home-manager/terminal/starship.nix
    ../modules/home-manager/terminal/voice.nix
    ../modules/home-manager/terminal/tiny-irc.nix
  ];
  home.packages = with pkgs; [
    tre-command
    diskonaut
    hyperfine
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  home.sessionVariables = {
    PIPENV_VENV_IN_PROJECT = 1;
    POETRY_VIRTUALENVS_IN_PROJECT = 1;
  };

  home.shellAliases = {
    # doc2pdf = "loffice --convert-to-pdf --headless *.docx";
  };

  programs = {
    zoxide.enable = true;
    tealdeer.enable = true;
  };
}
