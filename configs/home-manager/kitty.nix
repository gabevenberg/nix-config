{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    fira-code
    monocraft
    miracode
    nerd-fonts.symbols-only
  ];

  programs.kitty = {
    enable = true;
    # font.name = "Fira Code";
    font.name = "Monocraft";
    # font.name = "Miracode";
    themeFile = "gruvbox-dark";
    settings = {
      # background_opacity = "0.8";
      enable_audio_bell = "no";
      visual_bell_duration = "0.5";
      window_alert_on_bell = "yes";
      bell_on_tab = "🔔";
    };
  };
}
