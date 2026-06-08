{pkgs, ...}: {
  imports = [
    ./terminal.nix
    ../../configs/home-manager/nushell
  ];

  home.packages = with pkgs; [
    zig
    go-jsonnet
    typst
    go
    (luajit.withPackages (pkgs:
      with pkgs; [
        luajitPackages.fennel
        luajitPackages.readline
      ]))
    # steel
    rustup
    ruff
    uv
    python3
    python3Packages.ipython
    clang
    shellcheck
    # dhall
    # scbl
    # roswell
    # guile
    # janet
    # racket
    # ghc
    uiua
    gawk
    perl
    gforth
  ];

  wrappers.neovim.enable = true;
  wrappers.neovim.settings.minimal = false;

  home.sessionVariables.EDITOR = "nvim";
}
