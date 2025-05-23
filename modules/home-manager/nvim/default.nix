{
  configs,
  pkgs,
  helpers,
  lib,
  config,
  ...
}: {
  options.user.nvim.enable = lib.mkEnableOption "enable nvim";
  config = lib.mkIf config.user.nvim.enable {
    programs.nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      colorschemes.base16 = {
        colorscheme = "gruvbox-dark-medium";
        enable = true;
      };

      clipboard.providers.xsel.enable = true;
    };
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    programs.nushell.extraEnv = ''
      $env.EDITOR = 'nvim'
      $env.VISUAL = 'nvim'
    '';
  };

  imports = [
    ./keybinds.nix
    ./options.nix
    ./simpleplugins.nix
    ./lualine.nix
    ./nvim-tree.nix
    ./toggleterm.nix
    ./gitsigns.nix
    ./which-key.nix
    ./telescope.nix
    ./zk.nix
    ./treesitter
    ./cmp
    ./lsp
  ];
}
