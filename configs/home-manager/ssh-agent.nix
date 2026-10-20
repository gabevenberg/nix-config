{pkgs, ...}: {
  # macOS runs its own agent through launchd.
  services.ssh-agent.enable = pkgs.stdenv.hostPlatform.isLinux;
}
