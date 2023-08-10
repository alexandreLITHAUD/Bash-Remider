#!/usr/bin/zsh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

BOLD='\033[1m'      # Bold
UNDERLINE='\033[4m' # Underline
REVERSE='\033[7m'   # Reverse (inverts foreground and background colors)
RESET='\033[0m'     # Reset formatting

CHECKED='\u2611'
UNCHECKED='\u2610'

FILE_NAME='.sh-rem-data.yaml' #default .sh-rem-data.yaml


addValue(){ # Message  [Importance] default 3 
    if [$#=="1"]; then
        new_uuid=(uuidgen)
        yq eval ".I3 += {\"$new_uuid\": \"$1\"}" $FILE_NAME -i
    else
    
    fi;
}



# echo -e "${BOLD}This text is bold.${RESET}"
# echo -e "${UNDERLINE}This text is underlined.${RESET}"
# echo -e "${REVERSE}This text has reverse colors.${RESET}"

# echo -e "${RED}${BOLD}This is red text.${RESET}"
# echo -e "${GREEN}This is green text.${RESET}"
# echo -e "${YELLOW}This is yellow text.${RESET}"