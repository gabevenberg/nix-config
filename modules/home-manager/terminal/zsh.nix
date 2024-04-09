{
  config,
  pkgs,
  ...
}: {
  programs.starship.enableZshIntegration = true;
  programs.fzf.enableZshIntegration = true;
  programs.zoxide.enableZshIntegration = true;
  programs.yazi.enableZshIntegration = true;
  programs.direnv.enableZshIntegration = true;
  programs.kitty.shellIntegration.enableZshIntegration = true;
  services.gpg-agent.enableZshIntegration = true;
  programs.carapace.enableZshIntegration = false;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      #have the menu highlight while we cycle through options
      zstyle ':completion:*' menu select
      #case insensitive completion
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      #allow completion from midword
      setopt COMPLETE_IN_WORD
      #move cursor to end of word after completing
      setopt ALWAYS_TO_END
      #complete aliases as well
      setopt COMPLETE_ALIASES
      #select first item when you press tab the first time.
      setopt MENU_COMPLETE

    '';
    autocd = true;
    history = {
      ignoreAllDups = true;
      extended = true;
    };
    shellAliases = {
      ll = "ls -lh";
      la = "-lha";
      please = "sudo $(fc -ln -1)";
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
