{
  writeShellScriptBin,
  lib,
  jaq,
  libnotify,
  pipewire,
  wireplumber,
}:
writeShellScriptBin "switch-audio-out" ''
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

  jaq="${lib.getExe jaq}"

  notify() { ${libnotify}/bin/notify-send -a "switch-audio-out" -h string:x-canonical-private-synchronous:audio-route "$@" || true; }
  die() { notify -u critical -i dialog-error "Audio switch failed" "$1"; echo "$1" >&2; exit 1; }

  dump="$(${pipewire}/bin/pw-dump)"

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

  ${wireplumber}/bin/wpctl set-route "$sink_id" "$target" \
    || die "wpctl set-route $sink_id $target failed"

  notify -t 1000 -i "$icon" \
    "Audio Output" "Switched to $name"
''
