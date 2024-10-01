{
  config,
  pkgs,
  ...
}: {
  services.libinput = {
    # Enable touchpad support (enabled default in most desktopManager).
    enable = true;
    touchpad = {
      disableWhileTyping = true;
      naturalScrolling = true;
      additionalOptions = ''
        Option "PalmDetection" "True"
      '';
    };
  };
}
