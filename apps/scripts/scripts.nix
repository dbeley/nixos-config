{ pkgs }:
let
  notify = "${pkgs.libnotify}/bin/notify-send";
  pamixer = "${pkgs.pamixer}/bin/pamixer";
  systemctl = "${pkgs.systemd}/bin/systemctl";
in
{
  brightness = pkgs.writeShellScript "brightness" ''
    ${pkgs.brightnessctl}/bin/brightnessctl s "$1"
    level="$(${pkgs.brightnessctl}/bin/brightnessctl -m | cut -d, -f4 | tr -d '%')"
    ${notify} -t 500 "BRI $level%" \
      -h string:x-canonical-private-synchronous:brightness \
      -h int:value:"$level"
  '';

  volumePamixer = pkgs.writeShellScript "volume-pamixer" ''
    usage() {
      echo "Usage: volume-pamixer [up|bigup|down|bigdown|mute]" >&2
      exit 1
    }

    [ -z "$1" ] && usage

    case "$1" in
      up) ${pamixer} -i 1 ;;
      bigup) ${pamixer} -i 10 ;;
      down) ${pamixer} -d 1 ;;
      bigdown) ${pamixer} -d 10 ;;
      mute) ${pamixer} -t ;;
      *) usage ;;
    esac

    if [ "$1" != mute ]; then
      level="$(${pamixer} --get-volume-human)"
      ${notify} -t 500 "VOL $level" \
        -h string:x-canonical-private-synchronous:volume_pamixer \
        -h int:value:"$level"
    fi
  '';

  toggleGammastep = pkgs.writeShellScript "toggle-gammastep" ''
    status="$(${systemctl} --user is-active gammastep)"

    case "$status" in
      active)
        ${systemctl} --user stop gammastep
        ${notify} "gammastep is now disabled."
        ;;
      inactive)
        ${systemctl} --user start gammastep
        ${notify} "gammastep is now enabled."
        ;;
      *)
        ${notify} "gammastep is $status."
        ;;
    esac
  '';
}
