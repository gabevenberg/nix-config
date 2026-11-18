{
  config,
  lib,
  ...
}: {
  # When lockdown is enabled, the mkForce calls below wipe EVERY other firewall opening on the host.
  # Any port that must stay reachable during an incident (SSH is implied) has to be registered through host.details.lockdown.extraAllowed{TCP,UDP}Ports — setting networking.firewall.allowedTCPPorts elsewhere has no effect under lockdown.
  # tailscale0 and lo are fully trusted,
  # so services bound only to tailscale (e.g. blocky on cirrus) keep working without explicit exemptions.
  config = lib.mkIf config.host.details.lockdown.enable {
    networking.firewall = {
      enable = lib.mkForce true;
      allowedTCPPorts = lib.mkForce (config.services.openssh.ports ++ config.host.details.lockdown.extraAllowedTCPPorts);
      allowedUDPPorts = lib.mkForce config.host.details.lockdown.extraAllowedUDPPorts;
      allowedTCPPortRanges = lib.mkForce [];
      allowedUDPPortRanges = lib.mkForce [];
      trustedInterfaces = lib.mkForce ["tailscale0" "lo"];
      interfaces = lib.mkForce {};
    };
  };
}
