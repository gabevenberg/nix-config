{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    starship.enableZshIntegration = true;
    fzf.enableZshIntegration = true;
    zoxide.enableZshIntegration = true;
    yazi.enableZshIntegration = true;
    eza.enableZshIntegration = true;
    direnv.enableZshIntegration = true;
    kitty.shellIntegration.enableZshIntegration = true;
    carapace.enableZshIntegration = false;
    zsh = {
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
          #case insensitive globbing
          setopt NO_CASE_GLOB
          #sort globs that expand to numbers by number rather than alphabeticly
          setopt NUMERIC_GLOB_SORT
          #allows for some neat globbing.
          setopt EXTENDED_GLOB
          #allow backspacing beyond the point you entered insert mode:
          bindkey -v '^?' backward-delete-char
          bindkey "^W" backward-kill-word
          # Turn off terminal beep on autocomplete.
          unsetopt BEEP

          #cheat.sh is a wonderful tool, the less typing needed the better.
          cheat(){
            for i in "$@"; do
              curl cheat.sh/"$i"
            done
          }
          #the tre command has some shell integration.
          tre() { command tre "$@" --editor && source "/tmp/tre_aliases_$USER" 2>/dev/null; }
          tred() { command tre "$@" --editor=z --directories && source "/tmp/tre_aliases_$USER" 2>/dev/null; }

          #moves a file, leaving a symlink in its place.
          mvln(){
            set -eu

            # Check for correct number of arguments
            if [ "$#" -ne 2 ]; then
              echo "Usage: $0 <source> <destination>"
              exit 1
            fi
            source="$1" destination="$2"
            Check if source exists
            if [ ! -e "$source" ]; then
              echo "$source does not exist."
              exit 1
            fi

            mv -- "$source" "$destination"
            ln -s -- "$(realpath "$destination/$(basename "$source")")" "$(realpath "$source")"
          }
        ''
        (lib.mkIf (!config.programs.starship.enable) ''
          autoload -U promptinit
          promptinit
          autoload -U colors
          colors

          #stuff to show git things.
          autoload -Uz vcs_info
          setopt prompt_subst
          precmd_vcs() { vcs_info; }
          #when not in a repo, show full path to current directory. when in one, show path from base direcory of the repo.
          zstyle ':vcs_info:*' nvcsformats '%~'
          zstyle ':vcs_info:*' formats '%r/%S %F{green}[%b]%f'
          zstyle ':vcs_info:*' actionformats '%r/%S %F{green}[%b] %F{red}<%a>%f'

          #the precmd function, called just before printing the prompt.
          function precmd() { precmd_vcs; }

          #Make the right prompt blank, just to be sure.
          RPROMPT=""

          #on the top line, show a whole bunch of info. botton line should be as minimal as possible (just a single char to  input next to...)
          PROMPT=$'%F{cyan}[%n@%m]%f%F{red}├────┤%f$vcs_info_msg_0_ %F{white}[%D %T]%f\n»'
        '')
      ];
      autocd = true;
      autosuggestion.enable = true;
      defaultKeymap = "viins";
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
          "root"
          "line"
        ];
      };
    };
  };
  services.gpg-agent.enableZshIntegration = true;
  home.packages = with pkgs; [
    curl
    tre-command
  ];
}
