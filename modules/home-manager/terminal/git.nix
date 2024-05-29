{
  config,
  pgks,
  lib,
  ...
}: {
  options = {
    user.git = {
      enable= lib.mkEnableOption "enable git";
      workProfile = {
        enable = lib.mkEnableOption "git work profile";
        email = lib.mkOption {
          type = lib.types.str;
          description = "email for work profile.";
        };
      };
      profile = {
        email = lib.mkOption {
          type = lib.types.str;
          description = "email for main profile";
        };
        name = lib.mkOption {
          type = lib.types.str;
          description = "name for main profile";
        };
      };
    };
  };

  config = lib.mkIf config.user.git.enable {
    programs.git = {
      enable = true;
      aliases = {
        tree = "log-long-line --graph --topo-order --all --simplify-by-decoration";
        hist = "log-long-line --graph --date-order --date=short ";
        graph = "log-long-line --graph --topo-order --all";
        log-long-line = "log --pretty=format:'%C(auto)%h %C(cyan)%an %C(blue)%ar %C(auto)%d %s'";
        recent = "branch --sort=-committerdate --format='%(committerdate:relative)%09%(refname:short)'";
      };
      delta = {
        enable = true;
        options = {
          side-by-side = true;
          line-numbers = true;
        };
      };
      # difftastic.enable=true;
      # difftastic.background="dark";
      userEmail = config.user.git.profile.email;
      userName = config.user.git.profile.name;
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
      includes =
        if config.user.git.workProfile.enable
        then [
          {
            condition = "gitdir:~/work/**";
            contents.user.email = config.user.git.workProfile.email;
          }
        ]
        else [];
    };
    programs.lazygit.enable = true;
  };
}
