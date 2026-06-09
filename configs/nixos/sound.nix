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
    wireplumber.enable = true;
  };

  home-manager.users.${config.host.details.user} = {
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
            crosspipe
            easyeffects
          ]
        )
        [
          wiremix
          alsa-utils
          pipewire
        ]
      ];
  };
}
