{
  config,
  lib,
  pkgs,
  ...
}: let
  noctaliaConfig = "${config.home.homeDirectory}/.cache/noctalia/starship.toml";
  colour = token: "{{colors.${token}.default.hex}}";
in {
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "[](color_red)"
        "$shell"
        "$username"
        "[@](bg:color_red)"
        "$hostname"
        "[](bg:color_orange fg:color_red)"
        "\${env_var.SHPOOL_SESSION_NAME}"
        "$container"
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
        format = "[$hostname $ssh_symbol]($style)";
        style = "bg:color_red";
      };
      shell = {
        disabled = false;
        bash_indicator = "$";
        fish_indicator = "<><";
        zsh_indicator = "%";
        nu_indicator = ">";
        format = "[$indicator ]($style)";
        style = "bg:color_red";
      };
      fill = {
        symbol = " ";
        style = "bg:color_bg3";
      };
      username = {
        show_always = true;
        style_user = "bg:color_red fg:color_fg0";
        style_root = "bg:color_red fg:color_fg0";
        format = "[$user]($style)";
      };
      env_var.SHPOOL_SESSION_NAME = {
        disabled = false;
        symbol = "🌊";
        format = "[$symbol$env_value ]($style)";
        style = "bg:color_orange";
      };
      container = {
        disabled = false;
        symbol = "📦";
        format = "[$symbol$name ]($style)";
        style = "bg:color_orange";
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

  user.theme.targets.starship = {
    template = (pkgs.formats.toml {}).generate "starship-noctalia.toml" (config.programs.starship.settings
      // {
        palette = "noctalia";
        palettes.noctalia = {
          color_fg0 = colour "on_surface";
          color_bg1 = colour "surface_variant";
          color_bg3 = colour "terminal_selection_bg";
          color_blue = colour "terminal_normal_blue";
          color_aqua = colour "terminal_normal_cyan";
          color_green = colour "terminal_normal_green";
          color_orange = "{{colors.terminal_normal_red.default.hex | rotate_hue 20}}";
          color_purple = colour "terminal_normal_magenta";
          color_red = colour "terminal_normal_red";
          color_yellow = colour "terminal_normal_yellow";
        };
      });
    path = ".cache/noctalia/starship.toml";
  };

  programs.zsh.initContent = lib.mkIf config.user.theme.noctalia ''
    [[ -f ${noctaliaConfig} ]] && export STARSHIP_CONFIG=${noctaliaConfig}
  '';
  programs.nushell.extraEnv = lib.mkIf config.user.theme.noctalia ''
    if ("${noctaliaConfig}" | path exists) { $env.STARSHIP_CONFIG = "${noctaliaConfig}" }
  '';
}
