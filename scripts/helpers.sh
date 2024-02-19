#!/usr/bin/env bash


get_tmux_option() {
    local option=$1
    local default_value=$2
    local option_value="$(tmux show-option -gqv "$option")"

    if [[ -z "$option_value" ]]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

set_tmux_option() {
    local option=$1
    local value=$2
    tmux set-option -gq "$option" "$value"
}
# convert_units <KB> <decimal> 
convert_units() {
    input="$1"
    decimal="$2"
    number=$(echo "$input" | sed 's/[^0-9]*//g')

    if [ "$number" -lt 1024 ]; then
        unit="$number""KB"
    elif [ "$number" -lt 1048576 ]; then
        mb=$(echo "scale=$decimal; $number / 1024" | bc)
        unit="$mb""MB"
    else
        gb=$(echo "scale=$decimal; $number / 1048576" | bc)
        unit="$gb""GB"
    fi

    echo "$unit"
}

get_used(){
    local mnt=$(get_tmux_option "@quota_mount_point" "/dev/nvme1n1p1")
    quota -v | grep $mnt | awk '{print $2}'
}

get_limit(){
    local mnt=$(get_tmux_option "@quota_mount_point" "/dev/nvme1n1p1")
    quota -v | grep $mnt | awk '{print $3}'
}

# is second float bigger or equal?
fcomp() {
  awk -v n1="$1" -v n2="$2" 'BEGIN {if (n1<=n2) exit 0; exit 1}'
}

load_status() {
  local percentage=$1
  local prefix=$2
  medium_thresh=$(get_tmux_option "@${prefix}_medium_thresh" "30")
  high_thresh=$(get_tmux_option "@${prefix}_high_thresh" "80")
  if fcomp "$high_thresh" "$percentage"; then
    echo "high"
  elif fcomp "$medium_thresh" "$percentage" && fcomp "$percentage" "$high_thresh"; then
    echo "medium"
  else
    echo "low"
  fi
}