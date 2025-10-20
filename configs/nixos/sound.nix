{
  config,
  pkgs,
  lib,
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

  home-manager.users.${config.host.details.user} = {
    config,
    osConfig,
    lib,
    ...
  }: {
    home.packages = with pkgs;
      lib.mkMerge [
        (
          lib.mkIf (osConfig.host.details.gui.enable)
          [
            pwvucontrol
            helvum
          ]
        )
        [wiremix]
      ];
  };
}
