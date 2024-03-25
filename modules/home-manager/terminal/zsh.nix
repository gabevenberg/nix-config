{
  config,
  pkgs,
  ...
}: {
  programs.starship.enableZshIntegration = true;
  programs.fzf.enableZshIntegration = true;
  programs.zoxide.enableZshIntegration = true;
  programs.yazi.enableZshIntegration = true;
  programs.carapace.enableZshIntegration = true;
  programs.direnv.enableZshIntegration = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    history = {
      ignoreAllDups = true;
      extended = true;
    };
    shellAliases = {
      ll = "ls -lh";
      la = "-lha";
      please = "sudo $(fc -ln -1)";
      slideshow = "feh --full-screen --randomize --auto-zoom --recursive --slideshow-delay";
      pyactivate = "source ./.venv/bin/activate";
    };
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
        "pattern"
        "regexp"
        "cursor"
        "root"
        "line"
      ];
    };
  };
}
