{pkgs, ...}: {
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
    # gets overridden by noctalia if needed
    themeFile = "gruvbox-dark";
    settings = {
      enable_audio_bell = "no";
      visual_bell_duration = "0.5";
      window_alert_on_bell = "yes";
      bell_on_tab = "🔔";
    };
    keybindings = {
      # the default, kitty_mod+f3, is a stretch
      "kitty_mod+space" = "command_palette";
    };
  };

  user.theme.targets.kitty = {
    template = "${pkgs.noctalia}/share/noctalia/assets/templates/kitty/kitty.conf";
    # auto_reload_config picks it up
    path = ".config/kitty/themes/noctalia.conf";
  };
}
