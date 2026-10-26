{config, ...}: {
  hardware.enableRedistributableFirmware = true;

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

  home-manager.users.${config.host.details.user}.wayland.windowManager.niri.settings._children = [
    {
      output = {
        _args = ["Samsung Electric Company Odyssey G5 HNMY103123"];
        mode = "2560x1440@179.952";
        scale = 1;
        position._props = {
          x = 0;
          y = 0;
        };
      };
    }
    {
      output = {
        _args = ["Samsung Electric Company Odyssey G50F HNAL202494"];
        mode = "2560x1440@179.952";
        scale = 1;
        position._props = {
          x = 2560;
          y = 0;
        };
      };
    }
    {
      output = {
        _args = ["Vestel Elektronik Sanayi ve Ticaret A. S. 40FHD_LCD_TV Unknown"];
        off = {};
        mode = "1920x1080@60";
        position._props = {
          x = -1920;
          y = 0;
        };
      };
    }
  ];
}
