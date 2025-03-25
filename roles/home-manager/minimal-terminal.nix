{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../configs/home-manager/btop.nix
    ../../configs/home-manager/direnv.nix
    ../../configs/home-manager/ssh-agent.nix
    ../../configs/home-manager/zsh.nix
    ../../configs/home-manager/zellij
    ../../configs/home-manager/yazi.nix
  ];

  user = {
    git.enable = lib.mkDefault true;
    nvim.enable = lib.mkDefault true;
  };

  home.packages = with pkgs; [
    sshfs
    just
    dua
    fd
    sd
    file
    ripgrep
    curl
    rsync
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
    fzf.enable = true;
    eza.enable = true;
    ripgrep.enable = true;
    bat.enable = true;
    man.enable = true;
  };
}
