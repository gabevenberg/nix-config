{
  config,
  pkgs,
  lib,
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
    initExtra = lib.mkMerge [
      ''
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
      ''
      (lib.mkIf (!config.programs.starship.enable) ''
        autoload -U promptinit
        promptinit
        autoload -U colors
        colors

        #stuff to show git things.
          autoload -Uz vcs_info
          setopt prompt_subst
          precmd_vcs() {vcs_info}
          #when not in a repo, show full path to current directory. when in one, show path from base direcory of the repo.
          zstyle ':vcs_info:*' nvcsformats '%~'
          zstyle ':vcs_info:*' formats '%r/%S %F{green}[%b]%f'
          zstyle ':vcs_info:*' actionformats '%r/%S %F{green}[%b] %F{red}<%a>%f'

        #the precmd function, called just before printing the prompt.
        function precmd() {
          precmd_vcs
        }

        #Make the right prompt blank, just to be sure.
        RPROMPT=""

        #on the top line, show a whole bunch of info. botton line should be as minimal as possilbe (just a single char to  input next to...)
        PROMPT=$'%F{cyan}[%n@%m]%f%F{red}├────┤%f$${vcs_info_msg_0_} %F{white}[%D %T]%f\n»'
      '')
    ];
    autocd = true;
    history = {
      ignoreAllDups = true;
      extended = true;
    };
    shellAliases = {
      ll = "ls -lh";
      la = "ls -lha";
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
