#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

main() {
  local mnt=$(get_tmux_option "@quota_mount_point" "/dev/nvme1n1p1")
  local used=$(get_used)

  convert_units $used 0
}

main