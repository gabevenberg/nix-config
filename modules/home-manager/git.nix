{
  config,
  lib,
  ...
}: {
  options = {
    user.git = {
      enable = lib.mkEnableOption "enable git";
      includeDirs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        example = ["~/work"];
        description = "directories whose .gitconfig is included for repos under them.";
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
      enableGitIntegration = true;
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
          hash = "show -s --format=%H";
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
        lib.concatMap (dir: [
          {
            condition = "gitdir:${dir}/**";
            path = "${dir}/.gitconfig";
          }
        ])
        config.user.git.includeDirs;
    };
    # Warn if a .gitincludes is missing.
    home.activation.checkGitIncludes = lib.hm.dag.entryAfter ["writeBoundary"] (
      lib.concatMapStrings (dir: let
        file = "${dir}/.gitconfig";
        expanded =
          if lib.hasPrefix "~/" file
          then "$HOME/${lib.removePrefix "~/" file}"
          else file;
      in ''
        if [[ ! -f "${expanded}" ]]; then
          warnEcho "git: ${file} is missing, repos under ${dir} will use the main profile."
        fi
      '')
      config.user.git.includeDirs
    );
    programs.lazygit.enable = true;
    user.theme.targets.lazygit = {
      template = ./theme/templates/lazygit.yml;
      path = ".config/lazygit/config.yml";
    };
  };
}
