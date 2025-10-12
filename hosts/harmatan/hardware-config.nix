{config, ...}: {
  config.hardware.enableRedistributableFirmware = true;

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "sdhci_pci"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

  zramSwap = {
    enable = true;
    priority = 5;
  };
}
