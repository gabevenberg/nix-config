{
  config,
  pkgs,
  ...
}: {
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  home-manager.users.${config.host.details.user} = {config, ...}: {
    home.packages = with pkgs; [
      pwvucontrol
      helvum
    ];
  };
}
