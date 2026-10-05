{...}: {
  services.libinput = {
    # Enable touchpad support (enabled default in most desktopManager).
    enable = true;
    touchpad = {
      disableWhileTyping = true;
      naturalScrolling = true;
      accelSpeed = "0.5";
      additionalOptions = ''
        Option "PalmDetection" "True"
      '';
    };
  };
}
