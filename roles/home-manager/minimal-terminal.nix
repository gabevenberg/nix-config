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
    ../../configs/home-manager/yazi.nix
    ../../configs/home-manager/shpool.nix
    ./archive.nix
  ];

  user = {
    git.enable = lib.mkDefault true;
  };

  home.packages = with pkgs;
    [
      just
      dua
      duf
      fd
      sd
      trippy
      file
      ripgrep
      curl
      rsync
      jaq
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [sshfs];

  wrappers.neovim.enable = true;
  wrappers.neovim.settings.minimal = lib.mkDefault true;

  home.sessionVariables = {
    PIPENV_VENV_IN_PROJECT = 1;
    POETRY_VIRTUALENVS_IN_PROJECT = 1;
    UV_PYTHON_PREFERENCE = "managed";
  };

  user.theme.targets.bat = {
    template = ../../modules/home-manager/theme/templates/syntax.tmTheme;
    path = ".config/bat/themes/noctalia.tmTheme";
    reload = "bat cache --build";
  };

  home.sessionVariables.EDITOR = lib.mkDefault "nvim";

  home.sessionPath = [
    "$HOME/.nix-profile/bin/"
    "$HOME/.local/bin/"
    "$HOME/.cargo/bin/"
    "/opt/"
  ];

  home.shellAliases = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    sshmnt = "sshfs -o idmap=user,compression=no,reconnect,follow_symlinks,dir_cache=yes,ServerAliveInterval=15";
  };

  programs = {
    fzf.enable = true;
    eza = {
      enable = true;
      colors = "auto";
      git = true;
      icons = "auto";
    };
    ripgrep.enable = true;
    bat = {
      enable = true;
      config.theme = lib.mkDefault "gruvbox-dark";
    };
    man.enable = true;
  };
}
