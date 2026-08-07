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

        # Card to act on (alsa.card_name on the sink node). Find with:
        # pw-dump | jq -r '.[] | select(.info.props["media.class"] == "Audio/Sink") | .info.props["alsa.card_name"]'
        SINK="HD-Audio Generic"

        # The two output routes to cycle between. Find with:
        # pw-dump | jq '.[] | select(.info.props["device.name"] == "alsa_card.pci-0000_00_1f.3") | .info.params.EnumRoute[] | select(.direction == "Output") | {index, name, description, available}'
        ROUTE_A=3
        ICON_A="audio-headphones"
        ROUTE_B=4
        ICON_B="audio-speakers"

        jaq="${lib.getExe pkgs.jaq}"

        notify() { ${pkgs.dunst}/bin/dunstify --app-name "switch-audio-out" --stack-tag audio-route "$@" || true; }
        die() { notify -u critical -i dialog-error "Audio switch failed" "$1"; echo "$1" >&2; exit 1; }

        dump="$(${pkgs.pipewire}/bin/pw-dump)"

        # set-route needs the sink *node* id (it reads card.profile.device off the node).
        sink_id="$("$jaq" -r --arg n "$SINK" 'first(.[] | select(.info.props["media.class"] == "Audio/Sink" and .info.props["alsa.card_name"] == $n) | .id) // empty' <<<"$dump")"
        [ -n "$sink_id" ] || die "no sink found for card '$SINK'"

        # Which logical device within the card profile this sink is. Routes are per-device.
        cpd="$("$jaq" -r --argjson s "$sink_id" 'first(.[] | select(.id == $s) | .info.props["card.profile.device"]) // empty' <<<"$dump")"
        [ -n "$cpd" ] || die "sink $sink_id has no card.profile.device"

        # Its parent device carries the route info.
        dev_id="$("$jaq" -r --argjson s "$sink_id" 'first(.[] | select(.id == $s) | .info.props["device.id"]) // empty' <<<"$dump")"
        [ -n "$dev_id" ] || die "sink $sink_id has no parent device"

        # Active output route *for this sink's device*, not merely the first output route.
        cur="$("$jaq" -r --argjson d "$dev_id" --argjson p "$cpd" 'first(.[] | select(.id == $d) | .info.params.Route[]? | select(.direction == "Output" and .device == $p) | .index) // empty' <<<"$dump")"

        if [ "$cur" = "$ROUTE_A" ]; then target="$ROUTE_B"; icon="$ICON_B"; else target="$ROUTE_A"; icon="$ICON_A"; fi

        # Label from the cards route description.
        name="$("$jaq" -r --argjson d "$dev_id" --argjson r "$target" 'first(.[] | select(.id == $d) | .info.params.EnumRoute[]? | select(.index == $r) | .description) // empty' <<<"$dump")"
        [ -n "$name" ] || name="route $target"

        ${pkgs.wireplumber}/bin/wpctl set-route "$sink_id" "$target" \
          || die "wpctl set-route $sink_id $target failed"

        notify -t 1000 -i "$icon" \
          "Audio Output" "Switched to $name"
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

        xsession.windowManager.i3.config.keybindings = {
          "Mod4+ctrl+p" = "exec --no-startup-id ${lib.getExe switchAudioOutput}";
        };

        home.packages = with pkgs; [
          signal-desktop
          uhk-agent
          cameractrls
          v4l-utils
          gimp
          obs-studio
          yt-dlp
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
          ../../configs/home-manager/anki.nix
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
