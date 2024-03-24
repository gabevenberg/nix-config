{
  config,
  pkgs,
  lib,
  ...
}: {
  config =
    lib.mkIf config.host.nvim.enable-treesitter
    {
      programs.nixvim = {
        plugins.rainbow-delimiters = {
          enable = true;
          highlight = [
            "RainbowDelimiterYellow"
            "RainbowDelimiterBlue"
            "RainbowDelimiterOrange"
            "RainbowDelimiterGreen"
            "RainbowDelimiterViolet"
            "RainbowDelimiterCyan"
            # "RainbowDelimiterRed"
          ];
        };
      };
    };
}
