{
  inputs,
  outputs,
  ...
}:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
  extraSpecialArgs = {inherit inputs outputs;};
  modules = [
    inputs.nixvim.homeManagerModules.nixvim
    ({
      config,
      pkgs,
      lib,
      ...
    }: {
      # machine specific options
      user = {
        nvim = {
          enable-lsp = true;
          enable-treesitter = true;
        };
        git = {
          profile = {
            name = "Gabe Venberg";
            email = "gabevenberg@gmail.com";
          };
          workProfile = {
            enable = true;
            email = "venberggabe@johndeere.com";
          };
        };
      };

      targets.genericLinux.enable = true;
      home.username = "gabe";
      home.homeDirectory = /home/gabe;
      imports = [
        ../roles/home-manager/terminal.nix
        ../configs/home-manager/common.nix
        ../configs/home-manager/syncthing.nix
      ];
    })
  ];
}
