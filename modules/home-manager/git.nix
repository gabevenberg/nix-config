{
  config,
  pgks,
  lib,
  ...
}: {
  options = {
    user.git = {
      enable = lib.mkEnableOption "enable git";
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
    programs.delta = {
      enable = true;
      enableGitIntegration=true;
      options = {
        side-by-side = true;
        line-numbers = true;
      };
    };
    programs.git = {
      enable = true;
      settings = {
        alias = {
          tree = "log-long-line --graph --topo-order --all --simplify-by-decoration";
          hist = "log-long-line --graph --date-order --date=short";
          graph = "log-long-line --graph --topo-order --all";
          log-long-line = "log --pretty=format:'%C(auto)%h %C(cyan)%an %C(blue)%ar %C(auto)%d %s'";
          recent = "branch --sort=-committerdate --format='%(committerdate:relative)%09%(refname:short)'";
          track = "add -AN";
          hash = "git show -s --format=%H";
        };
        user = {
          email = config.user.git.profile.email;
          name = config.user.git.profile.name;
        };
        core.hooksPath = ".githooks";
        init.defaultBranch = "main";
        push = {
          autoSetupRemote = true;
          default = "simple";
          followTags = true;
        };
        fetch = {
          prune = true;
          pruneTags = true;
          all = true;
        };
        pull = {
          ff = true;
          rebase = "merges";
        };
        merge.conflictstyle = "zdiff3";
        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          mnemonicPrefix = true;
          renames = true;
        };
        rerere = {
          enabled = true;
          autoupdate = true;
        };
        rebase.autosquash = true;
        help.autocorrect = "prompt";
        branch.sort = "-committerdate";
        tag.sort = "version:refname";
        status.submodulesummary = true;
        submodule.recurse = true;
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
