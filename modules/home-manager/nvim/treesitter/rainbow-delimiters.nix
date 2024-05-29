{
  config,
  pkgs,
  lib,
  ...
}: {
  config =
    lib.mkIf (config.user.nvim.enable-treesitter && config.user.nvim.enable)
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
