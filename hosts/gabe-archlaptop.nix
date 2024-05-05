{
  inputs,
  outputs,
  ...
}:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
  extraSpecialArgs = {inherit inputs outputs;};
  modules = [
    ({
      config,
      pkgs,
      lib,
      ...
    }: {
      # machine specific options
      home = {
        enable-speech = true;
        nvim = {
          enable-lsp = true;
          enable-treesitter = true;
        };
        git = {
          profile = {
            name = "Gabe Venberg";
            email = "gabevenberg@gmail.com";
          };
          workProfile.enable = false;
        };
      };

      targets.genericLinux.enable = true;
      home.username = "gabe";
      home.homeDirectory = /home/gabe;
      imports = [
        ../modules/home-manager/terminal
        ../modules/home-manager/nvim
        ../modules/home-manager
        ../modules/home-manager/syncthing.nix
        ../modules/home-manager/beets.nix
        ../modules/home-manager/mpd/mpd.nix
        ../modules/home-manager/email.nix
      ];
    })
    inputs.nixvim.homeManagerModules.nixvim
  ];
}
