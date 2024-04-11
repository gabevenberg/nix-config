{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    sshfs
    just
    fd
    sd
    scc
    tre-command
    diskonaut
    hyperfine
    curl
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  home.sessionVariables = {
    PIPENV_VENV_IN_PROJECT = 1;
    POETRY_VIRTUALENVS_IN_PROJECT = 1;
  };

  home.sessionPath = [
    "$HOME/.nix-profile/bin/"
    "$HOME/.local/bin/"
    "$HOME/.cargo/bin/"
    "/opt/"
  ];

  home.shellAliases = {
    # doc2pdf = "loffice --convert-to-pdf --headless *.docx";
    sshmnt = "sshfs -o idmap=user,compression=no,reconnect,follow_symlinks,dir_cache=yes,ServerAliveInterval=15";
  };

  imports = [
    ./nushell
    ./zsh.nix
    ./git.nix
    ./starship.nix
    ./voice.nix
    ./zellij
    ./tiny-irc.nix
    ./ssh-agent.nix
  ];

  programs = {
    yazi.enable = true;
    zoxide.enable = true;
    fzf.enable = true;
    ripgrep.enable = true;
    bat.enable = true;
    tealdeer.enable = true;
    btop.enable = true;
    man.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
