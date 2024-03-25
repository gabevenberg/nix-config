{
  configs,
  pkgs,
  helpers,
  lib,
  ...
}: {
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
    ./treesitter/treesitter.nix
    ./cmp/cmp.nix
    ./lsp/lsp.nix
  ];
}
