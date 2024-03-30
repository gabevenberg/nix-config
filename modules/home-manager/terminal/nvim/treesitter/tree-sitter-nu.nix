{
  config,
  pkgs,
  lib,
  ...
}: {
  config =
    lib.mkIf config.host.nvim.enable-treesitter
    {
      programs.nixvim = let
        nu-grammar = pkgs.tree-sitter.buildGrammar {
          language = "nu";
          version = "0.0.0+rev=358c4f5";
          src = pkgs.fetchFromGitHub {
            owner = "nushell";
            repo = "tree-sitter-nu";
            rev = "c5b7816043992b1cdc1462a889bc74dc08576fa6";
            hash = "sha256-P+ixE359fAW7R5UJLwvMsmju7UFmJw5SN+kbMEw7Kz0=";
          };
        };
      in {
        # Set filetype to "nu" for files named "*.nu"
        filetype.extension.nu = "nu";

        # Add our nu parser to treesitter and associate it with nu filetype.
        extraConfigLua = ''
          local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
          parser_config.nu = {
            filetype = "nu",
          }
        '';

        # Add the nu injections
        extraFiles = {
          "/queries/nu/highlights.scm" = builtins.readFile "${nu-grammar}/queries/nu/highlights.scm";
          "/queries/nu/injections.scm" = builtins.readFile "${nu-grammar}/queries/nu/injections.scm";
          "/queries/nu/indents.scm" = builtins.readFile "${nu-grammar}/queries/nu/indents.scm";
        };

        plugins = {
          treesitter = {
            # Register the nu parser for files with "nu" filetype
            languageRegister.nu = "nu";
            grammarPackages =
              [
                nu-grammar
              ]
              ++ pkgs.vimPlugins.nvim-treesitter.allGrammars;
          };
        };
      };
    };
}
