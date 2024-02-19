#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

main() {
  local mnt=$(get_tmux_option "@quota_mount_point" "/dev/nvme1n1p1")
  local limit=$(get_limit)

  convert_units $limit 0
}

main