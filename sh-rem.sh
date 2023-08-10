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

# Work but - problem sometimes
addValue(){ # Message  [Importance] default 3
    new_uuid=$(uuidgen)
    if [ $# -eq 1 ]; then
        yq eval ".I3 += [{\"$new_uuid\": {\"$1\"}]" $FILE_NAME -i
    else
        yq eval ".I$2 += [{\"$new_uuid\": \"$1\"}]" $FILE_NAME -i
    fi;
}

printValues(){
    echo "on fait des test ici !!"

    # PRINT I1 FIRST (CHECK BEFORE UNCHECKED)
    # PRINT IN FIRST (CHECK BEFORE UNCHECKED)
    # PRINT IN+1 FIRST (CHECK BEFORE UNCHECKED)
}

helper(){
    echo "TODO"
    exit
}


case "$1" in
add) 
    if [ $# -eq 3 ]; then
        addValue $2 $3
    elif [ $# -eq 2 ]; then
        addValue $2
    else
        helper "add"
    fi;;
list)
    SHOW_VALUE=$(yq '.show' $FILE_NAME)
    if [ $SHOW_VALUE = "false" ]; then
        exit        
    fi;
    if [ $# -eq 2 ]; then
        printValues $2
    elif [ $# -eq 1 ]; then
        printValues
    else
        helper "list"
    fi;;
check) echo "TODO";;
prune) echo "TODO";;
del) echo "TODO";;
prune) echo "TODO";;
config) echo "TODO";;
modify) echo "TODO";;
link) echo "TODO";;
help) helper "help";;
esac


exit

# echo -e "${BOLD}This text is bold.${RESET}"
# echo -e "${UNDERLINE}This text is underlined.${RESET}"
# echo -e "${REVERSE}This text has reverse colors.${RESET}"

# echo -e "${RED}${BOLD}This is red text.${RESET}"
# echo -e "${GREEN}This is green text.${RESET}"
# echo -e "${YELLOW}This is yellow text.${RESET}"