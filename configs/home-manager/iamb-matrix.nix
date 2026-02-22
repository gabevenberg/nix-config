{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.iamb = {
    enable = true;
    settings = {
      profiles."matrix.org".user_id = "@gabev:matrix.org";
      settings = {
        image_preview.size = {
          height = 10;
          width = 80;
        };
        notifications.enabled = true;
      };
    };
  };
}
