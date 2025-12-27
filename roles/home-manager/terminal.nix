{
  inputs,
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

  home.packages = with pkgs; [
    ripgrep-all
    hyperfine
    fclones
    libqalculate
    f2
    inputs.nvim-config.packages.${pkgs.stdenv.hostPlatform.system}.nvim
    #TODO! move this to graphics module? This provides a drag and drop interface from the CLI.
    dragon-drop
  ];

  home.sessionVariables.EDITOR = "nvim";

  programs = {
    zoxide.enable = true;
    tealdeer.enable = true;
  };
}
