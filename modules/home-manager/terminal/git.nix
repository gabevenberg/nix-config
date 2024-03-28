{
  config,
  pgks,
  lib,
  ...
}: {
  options = {
    host.git.workProfile = {
      enable = lib.mkEnableOption "git work profile";
      email = lib.mkOption {
        type = lib.types.str;
        description = "email for work profile.";
      };
    };
    host.git.profile = {
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

  config = {
    programs.git = {
      enable = true;
      aliases = {
        hist = "log --graph --date-order --date=short --pretty=format:'%C(auto)%h%d %C(reset)%s %C(bold blue)%ce %C(reset)%C(green)%cr (%cd)'";
        graph = "log --graph --topo-order --all --pretty=format:'%C(auto)%h %C(cyan)%an %C(blue)%ar %C(auto)%d %s'";
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
      userEmail = config.host.git.profile.email;
      userName = config.host.git.profile.name;
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
        if config.host.git.workProfile.enable
        then [
          {
            condition = "gitdir:~/work/**";
            contents.user.email = config.host.git.workProfile.email;
          }
        ]
        else [];
    };
    programs.lazygit.enable = true;
  };
}
