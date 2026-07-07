# home desktop
{
  inputs,
  myLib,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {inherit inputs myLib;};
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./disk-config.nix
    ./hardware-config.nix
    ../../configs/nixos/common.nix
    ../../configs/nixos/sshd.nix
    ../../configs/nixos/interactive-networking.nix
    ../../configs/nixos/secrets.nix
    ../../configs/nixos/tailscale.nix
    ../../configs/nixos/syncthing.nix
    ../../configs/nixos/i3
    ../../configs/nixos/bluetooth.nix
    ../../configs/nixos/ntfy.nix
    ../../roles/nixos/gaming.nix
    ../../roles/nixos/embedded-dev
    ({
      config,
      pkgs,
      lib,
      ...
    }: let
      switchAudioOutput = pkgs.writeShellScriptBin "switch-audio-out" ''
        set -euo pipefail

        # to find this, run:
        # pw-dump | jq -r '.[] | select(.info.props["media.class"] == "Audio/Sink") | .info.props["alsa.card_name"]'
        SINK="HD-Audio Generic"   # device.nick from discovery step 1
        # to find these, run:
        # pw-dump | jq '.[] | select(.info.props["device.name"] == "alsa_card.pci-0000_00_1f.3") | .info.params.EnumRoute[] | select(.direction == "Output") | {index, name, description, available}'
        ROUTE_A=3
        ROUTE_B=4

        dump="$(${pkgs.pipewire}/bin/pw-dump)"

        # set-route needs the sink *node* id (it reads card.profile.device off the node).
        sink_id="$(${lib.getExe pkgs.jaq} -r --arg n "$SINK" \
          'first(.[] | select(.info.props["media.class"] == "Audio/Sink"
          and .info.props["alsa.card_name"] == $n) | .id) // empty' <<<"$dump")"

        # Its parent device carries the active-route info.
        dev_id="$(${lib.getExe pkgs.jaq} -r --argjson s "$sink_id" \
          'first(.[] | select(.id == $s) | .info.props["device.id"]) // empty' <<<"$dump")"

        # Current active output route index.
        cur="$(${lib.getExe pkgs.jaq} -r --argjson d "$dev_id" \
          'first(.[] | select(.id == $d) | .info.params.Route[]?
           | select(.direction == "Output") | .index) // empty' <<<"$dump")"

        if [ "$cur" = "$ROUTE_A" ]; then target="$ROUTE_B"; else target="$ROUTE_A"; fi
        ${pkgs.wireplumber}/bin/wpctl set-route "$sink_id" "$target"
      '';
    in {
      nixpkgs.hostPlatform = "x86_64-linux";
      host.details = {
        user = "gabe";
        fullName = "Gabe Venberg";
        gui.enable = true;
      };
      networking.hostName = "tempest";
      networking.hostId = "d46bca4f";

      services.displayManager.defaultSession = "none+i3";

      home-manager.sharedModules = [inputs.sops-nix.homeManagerModules.sops];
      home-manager.users.${config.host.details.user} = {
        inputs,
        osConfig,
        lib,
        ...
      }: {
        host.details = osConfig.host.details;
        user = {
          git = {
            profile = {
              name = config.host.details.fullName;
              email = "gabevenberg@gmail.com";
            };
          };
        };

        xsession.windowManager.i3.config.keybindings ={
          "Mod4+ctrl+p" = "exec --no-startup-id ${lib.getExe switchAudioOutput}";
        };

        home.packages = with pkgs; [
          signal-desktop
          uhk-agent
          cameractrls
          v4l-utils
        ];

        imports = [
          ../../roles/home-manager/terminal.nix
          ../../roles/home-manager/music.nix
          ../../roles/home-manager/3dprinting.nix
          ../../roles/home-manager/all_the_langs.nix
          ../../roles/home-manager/music-prod.nix
          ../../configs/home-manager/common.nix
          ../../configs/home-manager/secrets.nix
          ../../configs/home-manager/email.nix
          ../../configs/home-manager/senpai-irc.nix
          ../../configs/home-manager/ntfy.nix
          ../../configs/home-manager/kicad.nix
        ];

        sops = lib.mkIf (inputs ? nix-secrets) {
          secrets = {
            gmail-password.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
            irc-cert.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
            soju-password.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
          };
        };
      };

      systemd.services.disable-alsa-auto-mute = {
        description = "Disables the soundcards auto-mute so that the main speaker can still be used even when headphones are plugged in.";
        script = "${pkgs.alsa-utils}/bin/amixer -c \"Generic\" sset \"Auto-Mute Mode\" Disabled";
        wantedBy = ["multi-user.target"];
      };

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      # boot.loader.efi.canTouchEfiVariables = false;
      # without this, WOL causes the machine to boot right after shutdown.
      boot.kernelParams = ["xhci_hcd.quirks=270336"];

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.11"; # Did you read the comment?
    })
  ];
}
