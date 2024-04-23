{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "[](color_orange)"
        "$shell"
        "$username"
        "[@](bg:color_orange)"
        "$hostname"
        "[ ](bg:color_orange)"
        "[](bg:color_yellow fg:color_orange)"
        "$directory"
        "[](fg:color_yellow bg:color_aqua)"
        "$git_branch"
        "$git_status"
        "[](fg:color_aqua bg:color_blue)"
        "$git_metrics"
        "[](fg:color_blue bg:color_bg3)"
        "$git_commit"
        "[](fg:color_bg3 bg:color_bg1)"
        "$time"
        "[ ](fg:color_bg1)"
        "$line_break"
        "$character"
      ];
      add_newline = false;
      palette = "gruvbox_dark";
      palettes.gruvbox_dark = {
        color_fg0 = "#fbf1c7";
        color_bg1 = "#3c3836";
        color_bg3 = "#665c54";
        color_blue = "#458588";
        color_aqua = "#689d6a";
        color_green = "#98971a";
        color_orange = "#d65d0e";
        color_purple = "#b16286";
        color_red = "#cc241d";
        color_yellow = "#d79921";
      };
      hostname = {
        ssh_only = false;
        ssh_symbol = "🌐";
        format = "[$hostname$ssh_symbol]($style)";
        style = "bg:color_orange";
      };
      shell = {
        disabled = false;
        bash_indicator = "$";
        fish_indicator = "<><";
        zsh_indicator = "%";
        nu_indicator = ">";
        format = "[$indicator ]($style)";
        style = "bg:color_orange";
      };
      fill = {
        symbol = " ";
        style = "bg:color_bg3";
      };
      username = {
        show_always = true;
        style_user = "bg:color_orange fg:color_fg0";
        style_root = "bg:color_orange fg:color_fg0";
        format = "[$user]($style)";
      };
      directory = {
        style = "fg:color_fg0 bg:color_yellow";
        format = "[ $path ]($style)";
        fish_style_pwd_dir_length = 3;
        truncation_length = 4;
        truncation_symbol = "…/";
      };
      git_branch = {
        symbol = "";
        style = "bg:color_aqua";
        format = "[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)";
      };
      git_status = {
        style = "bg:color_aqua";
        format = "[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)";
      };
      git_metrics = {
        disabled = false;
        added_style = "bg:color_blue fg:bold green";
        deleted_style = "bg:color_blue fg:bold red";
        format = "([ +$added ]($added_style))([-$deleted ]($deleted_style))";
      };
      git_commit = {
        only_detached = false;
        tag_disabled = false;
        format = "[($hash$tag)]($style)";
        style = "bg:color_bg3";
      };
      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:color_bg1";
        format = "[[  $time ](fg:color_fg0 bg:color_bg1)]($style)";
      };
      line_break.disabled = false;
      character.disabled = false;
    };
  };
}
