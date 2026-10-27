{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    fira-code
    monocraft
    miracode
    ocr-a
    nerd-fonts.symbols-only
  ];

  programs.kitty = {
    enable = true;
    font.name = "Fira Code";
    # font.name = "Monocraft";
    # font.name = "Miracode";
    # fallback under noctalia's
    themeFile = "gruvbox-dark";
    # glob, so a missing file is fine
    extraConfig = "globinclude themes/noctalia.conf";
    settings = {
      # only noctalia's niri blurs whats behind the window
      background_opacity = lib.mkIf config.user.theme.noctalia "0.8";
      enable_audio_bell = "no";
      visual_bell_duration = "0.5";
      window_alert_on_bell = "yes";
      bell_on_tab = "🔔";
    };
  };

  user.theme.targets.kitty = {
    template = "${pkgs.noctalia}/share/noctalia/assets/templates/kitty/kitty.conf";
    # auto_reload_config picks it up
    path = ".config/kitty/themes/noctalia.conf";
  };
}
