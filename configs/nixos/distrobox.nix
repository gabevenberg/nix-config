{
  config,
  pkgs,
  lib,
  ...
}: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  home-manager.users.${config.host.details.user} = {config, ...}: {
  home.file.distroboxConf = {
    target = ".config/distrobox/distrobox.conf";
    text = ''
      container_additional_volumes="/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro"
    '';
  };

  home.packages = with pkgs; [
    distrobox
  ];
  };
}
