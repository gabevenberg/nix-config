{
  inputs,
  lib,
  ...
}: let
  # *Manually maintained*: tailscale IPs are stable in practice but can change if a node is deleted and re-added in the admin console.
  # `tailscale status` shows current assignments.
  # If an IP changes, update it here and redeploy cirrus —
  # blocky's bind address and the A-record mappings both derive from this table.
  tailscaleIps = {
    cirrus = "100.91.127.41";
    cirrostratus = "100.112.67.4";
    cumulus = "100.127.168.116";
    tempest = "100.121.56.92";
    harmatan = "100.104.169.113";
  };

  excludeHostnames = [
    # created by services.nginx.statusPage, not a real vhost
    "localhost"
    # add other vhost names here to keep them off the tailnet resolver
  ];

  vhostMappings = lib.pipe inputs.self.nixosConfigurations [
    (lib.filterAttrs (name: _: tailscaleIps ? ${name}))
    (lib.mapAttrsToList (
      name: cfg:
        lib.genAttrs
        (builtins.attrNames cfg.config.services.nginx.virtualHosts)
        (_: tailscaleIps.${name})
    ))
    (lib.foldl' lib.recursiveUpdate {})
    (lib.filterAttrs (hostname: _: !(builtins.elem hostname excludeHostnames)))
  ];
in {
  imports = [
    ./blocky.nix
  ];

  # cirrus is the tailnet's DNS resolver; don't point its own resolver at itself
  services.tailscale.extraSetFlags = ["--accept-dns=false"];

  # blocky binds to a tailscale IP; the interface and address must exist first
  systemd.services.blocky = {
    after = ["tailscaled.service"];
    wants = ["tailscaled.service"];
  };

  services.blocky.settings = {
    ports = {
      dns = "${tailscaleIps.cirrus}:53";
      # bind even if the tailscale address isn't assigned yet (tailscaled's Type=notify doesn't guarantee address assignment before READY)
      freeBind = true;
    };
    customDNS = {
      mapping = vhostMappings;
      # answer AAAA/TXT/etc. for mapped names locally (as empty) rather than leaking them to public upstreams
      filterUnmappedTypes = true;
    };
  };

  # If lockdown is enabled on cirrus,
  # these per-interface openings are force-cleared and access relies on tailscale0 being a trusted interface.
  networking.firewall.interfaces.tailscale0 = {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };
}
