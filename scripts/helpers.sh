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
