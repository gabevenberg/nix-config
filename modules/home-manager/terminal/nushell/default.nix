{
  config,
  pkgs,
  ...
}: {
  #sessionVariables, sessionPath and shellAliases are not applied to nushell.
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
  };

  home.file = {
    ".config/nushell/completions".source = ./completions;
  };

  programs.yazi.enableNushellIntegration = true;
  programs.zoxide.enableNushellIntegration = true;
  programs.starship.enableNushellIntegration = true;
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
  programs.direnv.enableNushellIntegration = true;
  services.gpg-agent.enableNushellIntegration = true;

  services.pueue = {
    enable = true;
    settings = {
      daemon = {
        default_parallel_tasks = 5;
      };
    };
  };
}
