{
  config,
  pkgs,
  ...
}: {
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput = {
    enable = true;
    disableWhileTyping = true;
    naturalScrolling = true;
    additionalOptions = ''
      Option "PalmDetection" "True"
    '';
  };
}
