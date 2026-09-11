{...}: {
  console.useXkbConfig = true;
  fonts.fontDir.enable = true;
  fonts.enableDefaultPackages = true;
  services.xserver.xkb.options = "ctrl:nocaps,compose:rctrl";
  # nixos defaults MiddleEmulation to on for every pointer, not just ones
  # without a physical middle button, so left+right together eats the click.
  services.libinput = {
    mouse.middleEmulation = false;
    touchpad.middleEmulation = false;
  };
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      bigclock = "en";
    };
  };
}
