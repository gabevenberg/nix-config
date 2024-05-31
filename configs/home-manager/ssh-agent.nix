{
  config,
  pkgs,
  lib,
  ...
}: {
  services.ssh-agent.enable = true;
  programs.nushell.extraEnv = ''
    $env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent"
  '';
}
