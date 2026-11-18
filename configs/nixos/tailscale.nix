{config, ...}: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
  # keep direct tailscale peer connections working during lockdown
  # (otherwise traffic falls back to DERP relays)
  host.details.lockdown.extraAllowedUDPPorts = [config.services.tailscale.port];
}
