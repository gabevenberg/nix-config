{
  config,
  lib,
  pkgs,
  ...
}: {
  options.user.nushell.enable = lib.mkEnableOption "enable nushell";
  config = lib.mkIf config.user.nushell.enable {
    home.file = {
      ".config/nushell/completions".source = ./completions;
    };

    programs = {
      #sessionVariables, sessionPath and shellAliases are not applied to nushell.
      nushell = {
        enable = true;
        configFile.source = ./config.nu;
        envFile.source = ./env.nu;
      };

      yazi.enableNushellIntegration = true;
      zoxide.enableNushellIntegration = true;
      starship.enableNushellIntegration = true;
      eza.enableNushellIntegration = true;
      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };
      direnv.enableNushellIntegration = true;
    };
    services = {
      gpg-agent.enableNushellIntegration = true;
      pueue = {
        enable = true;
        settings = {
          daemon = {
            default_parallel_tasks = 5;
          };
        };
      };
    };
  };
}
