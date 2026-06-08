{...}: {
  projectRootFile = "flake.nix";
  programs.typstyle = {
    enable = true;
    lineWidth = 120;
  };
}
