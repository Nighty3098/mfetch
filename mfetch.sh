#!/bin/bash

CPU=" "
RAM=" "
GPU=" "
OS=" "
DISK=" "
SHELL_ICO=" "
WM=" "
UPTIME=" "
KERNEL=" "
USER="  "
HELP=" "
PKGS=" "
IP_ICO=" "
RESOL_ICO=" "
MUSIC=" "

RESET="\e[0m"
BLACK="\e[1;30m"
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
BLUE="\e[1;34m"
MAGENTA="\e[1;35m"
CYAN="\e[1;36m"
WHITE="\e[1;37m"

RESET_BG="\e[7;0m"
BLACK_BG="\e[7;30m"
RED_BG="\e[7;31m"
GREEN_BG="\e[7;32m"
YELLOW_BG="\e[7;33m"
BLUE_BG="\e[7;34m"
MAGENTA_BG="\e[7;35m"
CYAN_BG="\e[7;36m"
WHITE_BG="\e[7;37m"

show_labels=true
selected_sections=()
DEFAULT_SECTIONS=("os" "kernel" "uptime" "shell" "wm" "colors")

clear

get_os_name() {
    lsb_release -d 2>/dev/null | cut -f2 || echo "Unknown"
}

function raw_ascii_art() {
    local os_name=$(get_os_name)
    
    declare -A os_art=(
        ["Kali GNU/Linux Rolling"]="${WHITE_BG}                  ${RESET_BG}\n${WHITE_BG}        NO        ${RESET_BG}\n${WHITE_BG}      SYSTEM      ${RESET_BG}\n${WHITE_BG}        IS        ${RESET_BG}\n${WHITE_BG}       SAFE       ${RESET_BG}\n${WHITE_BG}                  ${RESET_BG}"
        ["NixOS"]="${CYAN_BG}                  ${RESET_BG}\n${CYAN_BG}        ==\\      ${RESET_BG}\n${CYAN_BG}      //   //     ${RESET_BG}\n${CYAN_BG}      \\ ==       ${RESET_BG}\n${CYAN_BG}                  ${RESET_BG}\n${CYAN_BG}                  ${RESET_BG}"
        ["openSUSE Linux"|"openSUSE Tumbleweed"|"openSUSE"]="${GREEN_BG}                  ${RESET_BG}\n${GREEN_BG}       ,___       ${RESET_BG}\n${GREEN_BG}     _| () \      ${RESET_BG}\n${GREEN_BG}    /    --'      ${RESET_BG}\n${GREEN_BG}    \ ___^/       ${RESET_BG}\n${GREEN_BG}                  ${RESET_BG}"
        ["Arch Linux"]="${CYAN_BG}                  ${RESET_BG}\n${CYAN_BG}                  ${RESET_BG}\n${CYAN_BG}        /\        ${RESET_BG}\n${CYAN_BG}       /  \       ${RESET_BG}\n${CYAN_BG}      /_/\_\      ${RESET_BG}\n${CYAN_BG}                  ${RESET_BG}"
        ["Alpine Linux"]="${BLUE_BG}                  ${RESET_BG}\n${BLUE_BG}                  ${RESET_BG}\n${BLUE_BG}       /\         ${RESET_BG}\n${BLUE_BG}      // \/\      ${RESET_BG}\n${BLUE_BG}     //   \ \     ${RESET_BG}\n${BLUE_BG}                  ${RESET_BG}"
        ["Bedrock Linux"]="${WHITE_BG}                  ${RESET_BG}\n${WHITE_BG}     __           ${RESET_BG}\n${WHITE_BG}     \ \___       ${RESET_BG}\n${WHITE_BG}      \  _ \      ${RESET_BG}\n${WHITE_BG}       \___/      ${RESET_BG}\n${WHITE_BG}                  ${RESET_BG}"
        ["Debian Linux"]="${RED_BG}                  ${RESET_BG}\n${RED_BG}         __       ${RESET_BG}\n${RED_BG}      '/  .\'     ${RESET_BG}\n${RED_BG}      |  (_'      ${RESET_BG}\n${RED_BG}       \          ${RESET_BG}\n${RED_BG}                  ${RESET_BG}"
        ["EndeavourOS Linux"]="${MAGENTA_BG}                  ${RESET_BG}\n${MAGENTA_BG}         __       ${RESET_BG}\n${MAGENTA_BG}        /  \      ${RESET_BG}\n${MAGENTA_BG}      /     |     ${RESET_BG}\n${MAGENTA_BG}     '_____/      ${RESET_BG}\n${MAGENTA_BG}                  ${RESET_BG}"
        ["Manjaro Linux"]="${GREEN_BG}                  ${RESET_BG}\n${GREEN_BG}     ,___,,_,     ${RESET_BG}\n${GREEN_BG}     | ,_|| |     ${RESET_BG}\n${GREEN_BG}     | |  | |     ${RESET_BG}\n${GREEN_BG}     |_|__|_|     ${RESET_BG}\n${GREEN_BG}                  ${RESET_BG}"
        ["Ubuntu Linux"]="${YELLOW_BG}                  ${RESET_BG}\n${YELLOW_BG}        __        ${RESET_BG}\n${YELLOW_BG}     () -- ()     ${RESET_BG}\n${YELLOW_BG}     | |  | |     ${RESET_BG}\n${YELLOW_BG}      \ -- /      ${RESET_BG}\n${YELLOW_BG}                  ${RESET_BG}"
        ["MacOS"*]="${WHITE_BG}                  ${RESET_BG}\n${WHITE_BG}       _//_       ${RESET_BG}\n${WHITE_BG}     /  '' \      ${RESET_BG}\n${WHITE_BG}     |    (       ${RESET_BG}\n${WHITE_BG}      \____/      ${RESET_BG}\n${WHITE_BG}                  ${RESET_BG}"
    )
    
    if [[ -n "${os_art[$os_name]}" ]]; then
        echo -e "${os_art[$os_name]}"
    else
        echo -e "${MAGENTA_BG}                  ${RESET_BG}\n${MAGENTA_BG}    ┌──────┐      ${RESET_BG}\n${MAGENTA_BG}    │ ┌────┴─┐    ${RESET_BG}\n${MAGENTA_BG}    └─┤  >_  │    ${RESET_BG}\n${MAGENTA_BG}      └──────┘    ${RESET_BG}\n${MAGENTA_BG}                  ${RESET_BG}"
    fi
}

generate_section_info() {
    local section=$1
    
    case "$section" in
        "user")
            echo "  ${BLUE}$(whoami)@$(hostname)"
            ;;
        "os")
            echo "  OS: ${MAGENTA}$(get_os_name)"
            ;;
        "kernel")
            echo "  KR: ${RED}$(uname -r)"
            ;;
        "uptime")
            IFS=. read -r up _ < /proc/uptime
            echo "  UP: ${YELLOW}$((up / 60 / 60 / 24))D $((up / 60 / 60 % 24))H $((up / 60 % 60))M"
            ;;
        "shell")
            echo "  SH: ${CYAN}${SHELL##*/}"
            ;;
        "wm")
            echo "  WM: ${BLUE}${XDG_CURRENT_DESKTOP:-Unknown}"
            ;;
        "memory")
            echo "  RM: ${GREEN}$(free -h | awk '/Mem:/ {print $3 "/" $2}')"
            ;;
        "cpu")
            cpu_load=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
            cpu_info=$(lscpu | grep "Model name" | cut -d':' -f2 | sed -e 's/^[ \t]*//')
            [[ -z "$cpu_info" ]] && cpu_info=$(grep "model name" /proc/cpuinfo | head -n 1 | cut -d':' -f2 | sed -e 's/^[ \t]*//')
            cpu_cores=$(nproc)
            echo "  CP: ${YELLOW}${cpu_info:0:30} ($cpu_cores cores) - $cpu_load%"
            ;;
        "ip")
            echo "  IP: ${RED}$(ip route get 1 | awk '{print $7; exit}')"
            ;;
        "colors")
            echo "  ${BLACK} ${RED} ${GREEN} ${YELLOW} ${BLUE} ${MAGENTA} ${CYAN} ${WHITE} "
            ;;
        "battery")
            battery_path="/sys/class/power_supply/BAT0"
            percentage=$(cat "$battery_path/capacity")
            charge_full=$(cat "$battery_path/charge_full")
            charge_full_design=$(cat "$battery_path/charge_full_design")
            capacity=$(( charge_full * 100 / charge_full_design ))
            echo "  BT: ${BLUE}${percentage}% - ${capacity}%"
    esac
}

function display_info_side_by_side() {
    local art=()
    while IFS= read -r line; do
        art+=("$line")
    done < <(raw_ascii_art)
    
    local info_lines=()
    local sections_to_display=("${selected_sections[@]}")
    
    [[ ${#sections_to_display[@]} -eq 0 ]] && sections_to_display=("${DEFAULT_SECTIONS[@]}")
    
    for section in "${sections_to_display[@]}"; do
        info_lines+=("$(generate_section_info "$section")")
    done
    
    local art_width=0
    for line in "${art[@]}"; do
        line_plain=$(echo -e "$line" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")
        (( ${#line_plain} > art_width )) && art_width=${#line_plain}
    done
    
    for ((i=0; i<${#art[@]}; i++)); do
        local info_line="${info_lines[$i]-}"
        local art_line_plain=$(echo -e "${art[$i]}" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")
        local padding=$((art_width - ${#art_line_plain}))
        
        printf " %s%*s%b\n" "${art[$i]}" "$padding" "" "$info_line"
    done
}

declare -A valid_options=(
    ["--user"]="user"
    ["--os"]="os" 
    ["--kernel"]="kernel"
    ["--uptime"]="uptime"
    ["--shell"]="shell"
    ["--wm"]="wm"
    ["--memory"]="memory"
    ["--cpu"]="cpu"
    ["--ip"]="ip"
    ["--colors"]="colors"
    ["--battery"]="battery"
)

while [[ $# -gt 0 ]]; do
    case $1 in
        --labels)
            show_labels=true
            ;;
        --logo)
            raw_ascii_art
            exit 0
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo "Options:"
            for option in "${!valid_options[@]}"; do
                echo "  $option         Show ${valid_options[$option]} info"
            done
            echo "  --help         Show this help message"
            exit 0
            ;;
        *)
            if [[ -n "${valid_options[$1]}" ]]; then
                selected_sections+=("${valid_options[$1]}")
            else
                echo "Unknown option: $1"
                exit 1
            fi
            ;;
    esac
    shift
done


display_info_side_by_side

echo ""
