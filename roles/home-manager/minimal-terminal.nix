{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../modules/home-manager/terminal
    ../../modules/home-manager/nvim
  ];

  user = {
    btop.enable = true;
    direnv.enable = true;
    git.enable = true;
    ssh-agent.enable = true;
    zsh.enable = true;
    nvim.enable = true;
  };

  home.packages = with pkgs; [
    sshfs
    just
    fd
    sd
    curl
  ];

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

  programs = {
    yazi.enable = true;
    fzf.enable = true;
    eza.enable = true;
    ripgrep.enable = true;
    bat.enable = true;
    man.enable = true;
  };
}
