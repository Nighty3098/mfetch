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

show_labels=false
selected_sections=()

clear

function get_terminal_size() {
    local width
    local height
    width=$(tput cols)
    height=$(tput lines)
    echo "$width $height"
}

function center_text() {
    text=$@

    cols=$(tput cols)

    IFS=$'\n'$'\r'
    for line in $(echo -e "$text"); do
        line_length=$(echo "$line" | sed -r "s/\x1B\[([0-9]{1,1}(;[0-9]{1,2})?)?[m|K]//g" | wc -c)
        half_of_line_length=$((line_length / 2))
        is_odd=$((line_length % 2))
        half_of_line_length=$((half_of_line_length + is_odd))
        center=$(( (cols / 2) - half_of_line_length ))

        spaces=""
        for ((i=0; i < center; i++)); do
            spaces+=" "
        done
        printf "%s%s\n" "$spaces" "$line"
    done
}

function vertical_center_text() {
    text=$@

    rows=$(tput lines)

    text_length=$(echo -e "$text" | wc -l)
    half_of_text_length=$((text_length / 6))

    center=$(( (rows / 6) - half_of_text_length ))

    lines=""

    for ((i=0; i < center; i++)); do
        lines+="\n"
    done

    echo -e "${lines}${text}${lines}"
}


function raw_ascii_art() {
    os_name="$(lsb_release -d | cut -f2)"

    case "$os_name" in
        "openSUSE Linux" | "openSUSE Tumbleweed" | "openSUSE")
            echo -e "${GREEN_BG}                ${RESET_BG}"
            echo -e "${GREEN_BG}      ,___      ${RESET_BG}"
            echo -e "${GREEN_BG}    _| () \     ${RESET_BG}"
            echo -e "${GREEN_BG}   /    --'     ${RESET_BG}"
            echo -e "${GREEN_BG}   \ ___^/      ${RESET_BG}"
            echo -e "${GREEN_BG}                ${RESET_BG}";;
        "Arch Linux")
            echo -e "${CYAN_BG}                ${RESET_BG}"
            echo -e "${CYAN_BG}                ${RESET_BG}"
            echo -e "${CYAN_BG}       /\       ${RESET_BG}"
            echo -e "${CYAN_BG}      /  \      ${RESET_BG}"
            echo -e "${CYAN_BG}     /_/\_\     ${RESET_BG}"
            echo -e "${CYAN_BG}                ${RESET_BG}";;
        "Alpine Linux")
            echo -e "${BLUE_BG}                ${RESET_BG}"
            echo -e "${BLUE_BG}                ${RESET_BG}"
            echo -e "${BLUE_BG}      /\        ${RESET_BG}"
            echo -e "${BLUE_BG}     // \/\     ${RESET_BG}"
            echo -e "${BLUE_BG}    //   \ \    ${RESET_BG}"
            echo -e "${BLUE_BG}                ${RESET_BG}";;
        "Bedrock Linux")
            echo -e "${WHITE_BG}                ${RESET_BG}"
            echo -e "${WHITE_BG}    __          ${RESET_BG}"
            echo -e "${WHITE_BG}    \ \___      ${RESET_BG}"
            echo -e "${WHITE_BG}     \  _ \     ${RESET_BG}"
            echo -e "${WHITE_BG}      \___/     ${RESET_BG}"
            echo -e "${WHITE_BG}                ${RESET_BG}";;
        "Debian Linux")
            echo -e "${RED_BG}                ${RESET_BG}"
            echo -e "${RED_BG}        __      ${RESET_BG}"
            echo -e "${RED_BG}     '/  .\'    ${RESET_BG}"
            echo -e "${RED_BG}     |  (_'     ${RESET_BG}"
            echo -e "${RED_BG}      \         ${RESET_BG}"
            echo -e "${RED_BG}                ${RESET_BG}";;
        "EndeavourOS Linux")
            echo -e "${MAGENTA_BG}                ${RESET_BG}"
            echo -e "${MAGENTA_BG}        __      ${RESET_BG}"
            echo -e "${MAGENTA_BG}       /  \     ${RESET_BG}"
            echo -e "${MAGENTA_BG}     /     |    ${RESET_BG}"
            echo -e "${MAGENTA_BG}    '_____/     ${RESET_BG}"
            echo -e "${MAGENTA_BG}                ${RESET_BG}";;
        "Manjaro Linux")
            echo -e "${GREEN_BG}                ${RESET_BG}"
            echo -e "${GREEN_BG}    ,___,,_,    ${RESET_BG}"
            echo -e "${GREEN_BG}    | ,_|| |    ${RESET_BG}"
            echo -e "${GREEN_BG}    | |  | |    ${RESET_BG}"
            echo -e "${GREEN_BG}    |_|__|_|    ${RESET_BG}"
            echo -e "${GREEN_BG}                ${RESET_BG}";;
        "Ubuntu Linux")
            echo -e "${RED_BG}                ${RESET_BG}"
            echo -e "${RED_BG}       __       ${RESET_BG}"
            echo -e "${RED_BG}    () -- ()    ${RESET_BG}"
            echo -e "${RED_BG}    | |  | |    ${RESET_BG}"
            echo -e "${RED_BG}     \ -- /     ${RESET_BG}"
            echo -e "${RED_BG}       ''       ${RESET_BG}";;
        "MacOS Big Sur" | "MacOS Monterey" | "MacOS catalina" | "macOS high-sierra" | "macOS Mojave" | "macOS mountain lion" | "macOS mojave" | "macOS big sur" | "macOS catalina" | "macOS mojave" | "macOS yosemite")
            echo -e "${GREEN_BG}               ${RESET_BG}"
            echo -e "${GREEN_BG}     _//_      ${RESET_BG}"
            echo -e "${GREEN_BG}   /  '' \     ${RESET_BG}"
            echo -e "${GREEN_BG}   |    (      ${RESET_BG}"
            echo -e "${GREEN_BG}    \____/     ${RESET_BG}"
            echo -e "${GREEN_BG}               ${RESET_BG}";;
        *)
            echo -e "${WHITE_BG}                ${RESET_BG}"
            echo -e "${WHITE_BG}    /\ _ /\     ${RESET_BG}"
            echo -e "${WHITE_BG}  =( > w < )=_  ${RESET_BG}"
            echo -e "${WHITE_BG}    )  v  (_/ | ${RESET_BG}"
            echo -e "${WHITE_BG}   ( _\|/_ )_/  ${RESET_BG}"
            echo -e "${WHITE_BG}                ${RESET_BG}";;
    esac
    echo -e "${RESET_BG}             ${RESET_BG}"
}


function display_info_side_by_side() {
    local art=()
    while IFS= read -r line; do
        art+=("$line")
    done < <(raw_ascii_art)
    
    local info_text=()
    local info_colored=()
    
    for section in "${selected_sections[@]}"; do
        case "$section" in
            "user")
                info_text+=("${USER}$(whoami)@$(hostname)")
                info_colored+=(" ${BLUE}${USER}${WHITE}$(whoami)@$(hostname)")
                ;;
            "os")
                info_text+=("${OS} OS: $(lsb_release -d | cut -f2 2>/dev/null || echo "Unknown")")
                info_colored+=(" ${BLUE}${OS} OS: ${WHITE}$(lsb_release -d | cut -f2 2>/dev/null || echo "Unknown")")
                ;;
            "kernel")
                info_text+=("${KERNEL} Kernel: $(uname -r)")
                info_colored+=(" ${BLUE}${KERNEL} Kernel: ${WHITE}$(uname -r)")
                ;;
            "uptime")
                info_text+=("${UPTIME} Uptime: $(uptime -p | sed 's/up //')")
                info_colored+=(" ${BLUE}${UPTIME} Uptime: ${WHITE}$(uptime -p | sed 's/up //')")
                ;;
            "shell")
                info_text+=("${SHELL_ICO} Shell: $SHELL")
                info_colored+=(" ${BLUE}${SHELL_ICO} Shell: ${WHITE}$SHELL")
                ;;
            "wm")
                info_text+=("${WM} WM: ${XDG_CURRENT_DESKTOP:-Unknown}")
                info_colored+=(" ${BLUE}${WM} WM: ${WHITE}${XDG_CURRENT_DESKTOP:-Unknown}")
                ;;
            "memory")
                info_text+=("${RAM} Memory: $(free -h | awk '/Mem:/ {print $3 "/" $2}')")
                info_colored+=(" ${BLUE}${RAM} Memory: ${WHITE}$(free -h | awk '/Mem:/ {print $3 "/" $2}')")
                ;;
            "cpu")
                cpu_load=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
                cpu_info=$(lscpu | grep "Model name" | cut -d':' -f2 | sed -e 's/^[ \t]*//')
                if [ -z "$cpu_info" ]; then
                    cpu_info=$(cat /proc/cpuinfo | grep "model name" | head -n 1 | cut -d':' -f2 | sed -e 's/^[ \t]*//')
                fi
                cpu_cores=$(nproc)
                cpu_info="$cpu_info ($cpu_cores cores)"
                info_text+=("${CPU} CPU: $cpu_info")
                info_colored+=(" ${BLUE}${CPU} CPU: ${WHITE}$cpu_info - $cpu_load%")
                ;;
            "colors")
                info_text+=("        ")
                info_colored+=(" ${BLACK} ${RED} ${GREEN} ${YELLOW} ${BLUE} ${MAGENTA} ${CYAN} ${WHITE} ")
                ;;
        esac
    done
    
    if [ ${#selected_sections[@]} -eq 0 ]; then
        info_text=(
            "${USER}$(whoami)@$(hostname)"
            "${OS} OS: $(lsb_release -d | cut -f2 2>/dev/null || echo "Unknown")"
            "${UPTIME} Uptime: $(uptime -p | sed 's/up //')"
            "${SHELL_ICO} Shell: $SHELL"
            "${WM} WM: ${XDG_CURRENT_DESKTOP:-Unknown}"
            "        "
        )
        info_colored=(
            " ${BLUE}${USER}${WHITE}$(whoami)@$(hostname)"
            " ${BLUE}${OS} OS: ${WHITE}$(lsb_release -d | cut -f2 2>/dev/null || echo "Unknown")"
            " ${BLUE}${UPTIME} Uptime: ${WHITE}$(uptime -p | sed 's/up //')"
            " ${BLUE}${SHELL_ICO} Shell: ${WHITE}$SHELL"
            " ${BLUE}${WM} WM: ${WHITE}${XDG_CURRENT_DESKTOP:-Unknown}"
            " ${BLACK} ${RED} ${GREEN} ${YELLOW} ${BLUE} ${MAGENTA} ${CYAN} ${WHITE} "
        )
    fi
    
    local art_width=0
    for line in "${art[@]}"; do
        line_plain=$(echo -e "$line" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")
        (( ${#line_plain} > art_width )) && art_width=${#line_plain}
    done
    
    for ((i=0; i<${#art[@]}; i++)); do
        local info_plain="${info_text[$i]-}"
        local info_colored_line="${info_colored[$i]-}"
        
        local art_line_plain=$(echo -e "${art[$i]}" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")
        local current_padding=$((art_width - ${#art_line_plain}))
        
        printf " %s%*s%b\n" "${art[$i]}" "$current_padding" "" "$info_colored_line"
    done
}

while [[ "$1" != "" ]]; do
    case $1 in
        --labels)
            show_labels=true
            shift
            ;;
        --logo)
            raw_ascii_art
            exit 0
            ;;
        --user)
            selected_sections+=("user")
            shift
            ;;
        --os)
            selected_sections+=("os")
            shift
            ;;
        --kernel)
            selected_sections+=("kernel")
            shift
            ;;
        --uptime)
            selected_sections+=("uptime")
            shift
            ;;
        --shell)
            selected_sections+=("shell")
            shift
            ;;
        --wm)
            selected_sections+=("wm")
            shift
            ;;
        --memory)
            selected_sections+=("memory")
            shift
            ;;
        --cpu)
            selected_sections+=("cpu")
            shift
            ;;
        --colors)
            selected_sections+=("colors")
            shift
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --labels       Show labels for information"
            echo "  --logo         Show only logo"
            echo "  --user         Show user info"
            echo "  --os           Show OS info"
            echo "  --kernel       Show kernel info"
            echo "  --uptime       Show uptime"
            echo "  --shell        Show shell info"
            echo "  --wm           Show window manager info"
            echo "  --memory       Show memory usage"
            echo "  --cpu          Show cpu info"
            echo "  --colors       Show color palette"
            echo "  --help         Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

display_info_side_by_side
