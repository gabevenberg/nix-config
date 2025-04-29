{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  webUiPort = "8100";
  namespace = "pvpn";
  interface-name = "pvpn0";
  dnsIP = "DNS = 10.2.0.1";
  privateIP = "10.2.0.2/32";
  port = 8112;
  user = config.host.details.user;
  group = "users";
in {
  sops.secrets = lib.mkIf (inputs ? nix-secrets) {
    wg-config = {
      sopsFile = "${inputs.nix-secrets}/cirrostratus-protonvpn.conf";
      format = "binary";
      owner = config.host.details.user;
    };
  };
  # Id really like to setup the wg network with systemd,
  # but its not possible until systemd-networkd can manage network namespaces as well.
  systemd.services."netns@" = {
    description = "%I network namespace";
    before = ["network.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.iproute2}/bin/ip netns add %I";
      ExecStop = "${pkgs.iproute2}/bin/ip netns del %I";
    };
  };
  environment.etc."netns/${namespace}/resolv.conf".text = "nameserver ${dnsIP}";

  systemd.services.${namespace} = {
    description = "${namespace} network interface";
    bindsTo = ["netns@${namespace}.service"];
    requires = ["network-online.target"];
    after = ["netns@${namespace}.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = with pkgs;
        writers.writeBash "wg-up" ''
          set -e
          ${iproute2}/bin/ip link add ${interface-name} type wireguard
          ${iproute2}/bin/ip link set ${interface-name} netns ${namespace}
          ${iproute2}/bin/ip -n ${namespace} address add ${privateIP} dev ${interface-name}
          ${iproute2}/bin/ip netns exec ${namespace} \
          ${pkgs.wireguard-tools}/bin/wg setconf ${interface-name} ${config.sops.secrets.wg-config.path}
          ${iproute2}/bin/ip -n ${namespace} link set ${interface-name} up
          ${iproute2}/bin/ip -n ${namespace} link set lo up
          ${iproute2}/bin/ip -n ${namespace} route add default dev ${interface-name}
        '';
      ExecStop = with pkgs;
        writers.writeBash "wg-down" ''
          set -e
          ${iproute2}/bin/ip -n ${namespace} route del default dev ${interface-name}
          ${iproute2}/bin/ip -n ${namespace} link del ${interface-name}
        '';
    };
  };
  # now we get to the deluge stuff.
  services.deluge = {
    enable = true;
    user = user;
    group = group;
    web = {
      enable = true;
      port = port;
    };
  };
  # binding deluged to network namespace
  systemd.services.deluged.bindsTo = ["netns@${namespace}.service"];
  systemd.services.deluged.requires = ["network-online.target" "${namespace}.service"];
  systemd.services.deluged.serviceConfig.NetworkNamespacePath = ["/var/run/netns/${namespace}"];

  # allowing delugeweb to access deluged in network namespace, a socket is necesarry
  systemd.sockets."proxy-to-deluged" = {
    enable = true;
    description = "Socket for Proxy to Deluge Daemon";
    listenStreams = ["58846"];
    wantedBy = ["sockets.target"];
  };

  # creating proxy service on socket, which forwards the same port from the root namespace to the isolated namespace
  systemd.services."proxy-to-deluged" = {
    enable = true;
    description = "Proxy to Deluge Daemon in Network Namespace";
    requires = ["deluged.service" "proxy-to-deluged.socket"];
    after = ["deluged.service" "proxy-to-deluged.socket"];
    unitConfig = {JoinsNamespaceOf = "deluged.service";};
    serviceConfig = {
      User = user;
      Group = group;
      ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:58846";
      PrivateNetwork = "yes";
    };
  };
}
