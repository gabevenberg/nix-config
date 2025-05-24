{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zk = {
    enable = true;
    settings = {
      notebook.dir = "~/notes";

      note = {
        language = "en";
        default-title = "untitled";
        filename = "{{slug title}}-{{id}}";
        id-charset = "hex";
        id-length = 8;
        id-case = "lower";
      };

      format.markdown = {
        link-format = "[[{{filename}}]]";
        hashtags = true;
      };

      alias = {
        bl = ''zk list --link-to $@'';
        i = ''zk edit --interactive'';
        unlinked-mentions-by = ''zk list --mentioned-by "$@" --no-linked-by "$@"'';
        unlinked-mentions-to = ''zk list --mention "$@" --no-link-to "$@"'';
        mentions-tags = ''zk list --tag "NOT "$@"" --match "$@"'';
        short = ''zk list --format '{{word-count}}\t{{title}}' --limit 20 --sort word-count $@'';
        nt = ''zk new --title "''${*:2}" $1'';
        todo = ''zk list --tag=TODO'';
      };

      tool = {
        fzf-preview = "bat -p --color always {-1}";
      };

      lsp = {
        diagnostics = {
          wiki-title = "hint";
          dead-link = "error";
        };
        completion = {
          note-label = "{{title-or-path}}";
          note-filter-text = "{{title}} {{path}}";
          note-detail = "{{filename}}";
        };
      };
    };
  };
}
