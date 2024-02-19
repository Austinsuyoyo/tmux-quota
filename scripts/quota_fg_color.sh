#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/helpers.sh"

quota_low_fg_color=""
quota_medium_fg_color=""
quota_high_fg_color=""

quota_low_default_fg_color="#[fg=green]"
quota_medium_default_fg_color="#[fg=yellow]"
quota_high_default_fg_color="#[fg=red]"

get_fg_color_settings() {
  quota_low_fg_color=$(get_tmux_option "@quota_low_fg_color" "$quota_low_default_fg_color")
  quota_medium_fg_color=$(get_tmux_option "@quota_medium_fg_color" "$quota_medium_default_fg_color")
  quota_high_fg_color=$(get_tmux_option "@quota_high_fg_color" "$quota_high_default_fg_color")
}

print_fg_color() {
  local quota_percentage
  local load_status
  quota_percentage=$("$CURRENT_DIR"/quota_percentage.sh | sed -e 's/%//')
  load_status=$(load_status "$quota_percentage" "quota")
  if [ "$load_status" == "low" ]; then
    echo "$quota_low_fg_color"
  elif [ "$load_status" == "medium" ]; then
    echo "$quota_medium_fg_color"
  elif [ "$load_status" == "high" ]; then
    echo "$quota_high_fg_color"
  fi
}

main(){
    get_fg_color_settings
    print_fg_color
}

main "$@"