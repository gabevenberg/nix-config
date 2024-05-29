{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf (config.user.nvim.enable && config.user.nvim.enable-lsp) {
    home.file = {
      ".clangd".text = ''
        # keeps clangd from choking when it sees a compiler flag for a different
        # compiler. (sutch as when acting as an lsp for a project that uses GCC.)
        CompileFlags:
          Add: -Wno-unknown-warning-option
          Remove: [-m*, -f*]
      '';
      ".clang-format".text = ''
        ---
        #this syncronizes with settings used by neovims treesitters so that the lsp formatting and treesitter formatting do not fight eatch other.
        PointerAlignment: Left
        ColumnLimit: 80
        IndentWidth: 4
        TabWidth: 4
        UseCRLF: false
        UseTab: Never
        AlignAfterOpenBracket: BlockIndent
        AlwaysBreakBeforeMultilineStrings: true
        BreakBeforeBraces: Attach
        AlignOperands: Align
        BreakBeforeBinaryOperators: NonAssignment
        ...
      '';
      "work/.clang-format" = lib.mkIf config.user.git.workProfile.enable {
        text = ''
          ---
          #this syncronizes with settings used by neovims treesitters so that the lsp formatting and treesitter formatting do not fight eatch other.
          PointerAlignment: Left
          ColumnLimit: 80
          IndentWidth: 4
          TabWidth: 4
          UseCRLF: false
          UseTab: Never
          AlignAfterOpenBracket: BlockIndent
          AlwaysBreakBeforeMultilineStrings: true
          BreakBeforeBraces: Allman
          BreakBeforeBinaryOperators: None
          ...
        '';
      };
    };
  };
}
