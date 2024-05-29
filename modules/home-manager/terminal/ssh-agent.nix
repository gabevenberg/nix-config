{
  config,
  pkgs,
  lib,
  ...
}: {
  options.user.ssh-agent.enable = lib.mkEnableOption "enable ssh-agent";
  config = lib.mkIf config.user.ssh-agent.enable {
    services.ssh-agent.enable = true;
    programs.nushell.extraEnv = ''
      $env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent"
    '';
  };
}
