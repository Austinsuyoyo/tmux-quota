#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$CURRENT_DIR/scripts/helpers.sh"

quota_placeholders=(
    "\#{quota_space_used}"
    "\#{quota_space_limit}"
)
quota_commands=(
    "#($CURRENT_DIR/scripts/quota_space_used.sh)"
    "#($CURRENT_DIR/scripts/quota_space_limit.sh)"
)

replace_placeholder() {
  local value="$1"
  for ((i=0; i<${#quota_commands[@]}; i++)); do
    value=${value//${quota_placeholders[$i]}/${quota_commands[$i]}}
  done
  echo "$value"
}

update_tmux_option() {
  local option=$1
  local old_option_value=$(get_tmux_option "$option")
  local new_option_value=$(replace_placeholder "$old_option_value")

  echo "old: $old_option_value"
  echo "new: $new_option_value"
  $(set_tmux_option $option "$new_option_value")
}

main() {
	update_tmux_option "status-right"
	update_tmux_option "status-left"
}
main