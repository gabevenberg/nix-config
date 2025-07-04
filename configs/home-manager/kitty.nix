{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode Nerd Font";
    };
    themeFile = "gruvbox-dark";
    settings = {
      background_opacity = "0.8";
      enable_audio_bell = "no";
      visual_bell_duration = "0.5";
      window_alert_on_bell = "yes";
      bell_on_tab = "🔔";
    };
  };
}
