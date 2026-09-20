{...}: {
  programs.rofi = {
    enable = true;
    settings = {
      location = 2;
      terminal = "kitty";
    };
    theme = "gruvbox-dark-soft";
  };
}
