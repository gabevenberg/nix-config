{
  writeShellScriptBin,
  lib,
  gawk,
}:
writeShellScriptBin "tv" ''
  set -euo pipefail

  output=HDMI-A-1

  usage() {
    echo "Usage: tv [on|off|toggle]" >&2
    exit 2
  }

  # Prints on, off, or nothing while the TV is in standby and so not connected
  state() {
    niri msg outputs | ${lib.getExe gawk} -v want="($output)" '
      found { print ($1 == "Disabled" ? "off" : "on"); exit }
      $1 == "Output" && $NF == want { found = 1 }
    '
  }

  case "''${1:-toggle}" in
  on | off) action=$1 ;;
  toggle)
    case "$(state)" in
    on) action=off ;;
    off) action=on ;;
    *)
      echo "$output is not connected, cannot toggle. Use tv on or tv off." >&2
      exit 1
      ;;
    esac
    ;;
  *) usage ;;
  esac

  niri msg output "$output" "$action"
''
