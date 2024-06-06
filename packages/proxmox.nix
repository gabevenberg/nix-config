{
  inputs,
  outputs,
  configLib,
  ...
}:
inputs.nixos-generators.nixosGenerate {
  system = "x86_64-linux";
  specialArgs = {inherit inputs outputs configLib;};
  format = "proxmox-lxc";
  modules = [
    inputs.home-manager.nixosModules.home-manager
    ../configs/nixos/sshd.nix
    ../configs/nixos/common.nix
    ({
      config,
      pkgs,
      configLib,
      modulesPath,
      ...
    }: {
      imports = [(modulesPath + "/virtualisation/proxmox-lxc.nix")];
      proxmoxLXC.manageHostName = false;
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
}
