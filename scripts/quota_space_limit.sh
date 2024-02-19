#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$CURRENT_DIR/helpers.sh"

main() {
  local mnt="$(get_mount_point)"

  quota -s | grep $mnt | awk '{print $3}'
}

main