{
  inputs,
  myLib,
  ...
}:
(inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs myLib;};
  modules = [
    inputs.home-manager.nixosModules.home-manager
    ../configs/nixos/sshd.nix
    ../configs/nixos/common.nix
    ({
      config,
      pkgs,
      modulesPath,
      lib,
      ...
    }: {
      imports = ["${modulesPath}/virtualisation/proxmox-lxc.nix"];
      proxmoxLXC.manageHostName = false;
      boot.loader.grub.enable = lib.mkForce false;
      boot.loader.systemd-boot.enable = lib.mkForce false;
      host.details = {
        user = "gabe";
        fullName = "Gabe Venberg";
      };

      home-manager.users.${config.host.details.user} = {
        inputs,
        osConfig,
        ...
      }: {
        host.details = osConfig.host.details;
        user = {
          git = {
            profile = {
              name = config.host.details.fullName;
              email = "gabevenberg@gmail.com";
            };
            workProfile.enable = false;
          };
        };
        imports = [
          ../roles/home-manager/minimal-terminal.nix
          ../configs/home-manager/common.nix
        ];
      };

      system.stateVersion = "24.05";
    })
  ];
})
.config
.system
.build
.tarball
