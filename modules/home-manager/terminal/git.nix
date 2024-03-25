{
  config,
  pgks,
  ...
}: {
  programs.git = {
    enable = true;
    aliases = {
      hist = "log --graph --date-order --date=short --pretty=format:'%C(auto)%h%d %C(reset)%s %C(bold blue)%ce %C(reset)%C(green)%cr (%cd)'";
      graph = "log --graph --topo-order --all --pretty=format:'%C(auto)%h %C(cyan)%an %C(blue)%ar %C(auto)%d %s'";
      recent = "branch --sort=-committerdate --format='%(committerdate:relative)%09%(refname:short)'";
    };
    delta.enable = true;
    # difftastic.enable=true;
    # difftastic.background="dark";
    userEmail = "gabevenberg@gmail.com";
    userName = "Gabe Venberg";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
        default = "current";
      };
      pull = {
        ff = true;
      };
      merge = {
        conflictstyle = "zdiff3";
      };
      rebase = {
        autosquash = true;
      };
      help = {
        autocorrect = "prompt";
      };
      branch = {
        sort = "-committerdate";
      };
      status = {
        submodulesummary = true;
      };
    };
    includes = [
      {
        condition = "gitdir:~/work/";
        contents = {
          user = {
            email = "venberggabe@johndeere.com";
          };
        };
      }
    ];
  };
  programs.lazygit.enable = true;
}
