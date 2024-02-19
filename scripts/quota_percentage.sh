#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

quota_percentage_format="%3.1f%%"

main() {
  quota_percentage_format=$(get_tmux_option "@quota_percentage_format" "$quota_percentage_format")

  local mnt=$(get_tmux_option "@quota_mount_point" "/dev/nvme1n1p1")
  local used=$(get_used)
  local limit=$(get_limit)

  echo "$used $limit" | awk -v format="$quota_percentage_format" '{printf format, $1 / $2 * 100}'
}

main