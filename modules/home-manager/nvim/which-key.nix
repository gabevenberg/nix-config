{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.user.nvim.enable {
    programs.nixvim = {
      opts = {
        timeout = true;
        timeoutlen = 300;
      };
      plugins.which-key = {
        enable = true;
        # TODO: remvoe this once https://github.com/nix-community/nixvim/issues/1901 is fixed.
        package = pkgs.vimPlugins.which-key-nvim.overrideAttrs (oldAttrs: {
            src = pkgs.fetchFromGitHub {
              owner = oldAttrs.src.owner;
              repo = oldAttrs.src.repo;
              rev = "0539da005b98b02cf730c1d9da82b8e8edb1c2d2"; # v2.1.0
              hash = "sha256-gc/WJJ1s4s+hh8Mx8MTDg8pGGNOXxgKqBMwudJtpO4Y=";
            };
          });
      };
    };
  };
}
