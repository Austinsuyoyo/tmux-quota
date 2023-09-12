#!/usr/bin/env bash

disk=/dev/nvme1n1p1

quota_interpolations=(
    "\#{quota_space_used}"
    "\#{quota_space_limit}"
)
quota_interpolation_cmd=(
    "quota -s | grep '/dev/nvme1n1p1' | awk '{print \$2}'"
    "quota -s | grep '/dev/nvme1n1p1' | awk '{print \$3}'"
)

set_tmux_option() {
    local option=$1
    local value=$2
    tmux set-option -gq "$option" "$value"
}

do_interpolation() {
    local result="$1"
    for ((i=0; i < ${#quota_interpolations[@]}; i++)); do
        local cmd="${quota_interpolation_cmd[$i]}"
        cmd="#(${cmd})"
	    result="${result//${quota_interpolations[$i]}/${cmd}}"
    done
    echo "$result"
}

update_tmux_option() {
	local option=$1
	local option_value=$(get_tmux_option "$option")
	local new_option_value=$(do_interpolation "$option_value")
	set_tmux_option "$option" "$new_option_value"
}

main() {
	update_tmux_option "status-right"
	update_tmux_option "status-left"
}
main