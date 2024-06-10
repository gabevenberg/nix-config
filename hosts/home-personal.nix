{
  inputs,
  configLib,
  ...
}:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
  extraSpecialArgs = {inherit inputs configLib;};
  modules = [
    ({
      config,
      pkgs,
      lib,
      configLib,
      ...
    }: {
      # machine specific options
      user = {
        enable-speech = true;
        git = {
          profile = {
            name = "Gabe Venberg";
            email = "gabevenberg@gmail.com";
          };
          workProfile.enable = false;
        };
      };
      host.isLaptop = true;

      targets.genericLinux.enable = true;
      home.username = "gabe";
      home.homeDirectory = /home/gabe;
      imports = [
        ../roles/home-manager/terminal.nix
        ../roles/home-manager/music.nix
        ../configs/home-manager/common.nix
        ../configs/home-manager/syncthing.nix
        ../configs/home-manager/email.nix
        ../configs/home-manager/tiny-irc.nix
        ../configs/home-manager/secrets.nix
        inputs.sops-nix.homeManagerModules.sops
      ];

      sops = {
        secrets = {
          gmail-password.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
          irc-cert.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
        };
      };
    })
    inputs.nixvim.homeManagerModules.nixvim
  ];
}
