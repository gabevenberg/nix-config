{
  inputs,
  outputs,
  configLib,
  ...
}:
(inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs outputs configLib;};
  modules = [
    inputs.home-manager.nixosModules.home-manager
    ../configs/nixos/sshd.nix
    ../configs/nixos/common.nix
    ({
      config,
      pkgs,
      configLib,
      modulesPath,
      lib,
      ...
    }: {
      imports = ["${modulesPath}/virtualisation/proxmox-lxc.nix"];
      proxmoxLXC.manageHostName = false;
      boot.loader.grub.enable = lib.mkForce false;
      boot.loader.systemd-boot.enable = lib.mkForce false;
      host.user = "gabe";
      host.fullName = "Gabe Venberg";

      home-manager.users.${config.host.user} = {
        inputs,
        osConfig,
        ...
      }: {
        host = osConfig.host;
        user = {
          git = {
            profile = {
              name = config.host.fullName;
              email = "gabevenberg@gmail.com";
            };
            workProfile.enable = false;
          };
        };
        imports = [
          ../roles/home-manager/minimal-terminal.nix
          ../configs/home-manager/common.nix
          inputs.nixvim.homeManagerModules.nixvim
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
