{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./terminal.nix
    ../../configs/home-manager/nushell
  ];

  home.packages = with pkgs; [
    zig
    go-jsonnet
    typst
    go
    (luajit.withPackages (ps: with ps; [
      luajitPackages.fennel
      luajitPackages.readline
    ]))
    # steel
    rustup
    ruff
    python3
    libclang
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
