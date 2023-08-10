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
    new_uuid=$(uuidgen)
    if [ $# -eq 1 ]; then
        default_value=$(yq '.default' $FILE_NAME)
        yq eval ".I$default_value += [{\"$new_uuid\": {\"$1\"}]" $FILE_NAME -i
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
    
    if [ $# -eq 1 ]; then
        case "$1" in
        add) 
            echo "${RED}${BOLD}Usage : sh-rem add <message> [importance default=3]${RESET}";;
        list)
            echo "${RED}${BOLD}Usage : sh-rem list [importance]${RESET}";;
        del)
            echo "${RED}${BOLD}Usage : sh-rem del <uuid>${RESET}";;
        prune)
            echo "${RED}${BOLD}Usage : sh-rem prune [importance]${RESET}";;
        modify)
            echo "${RED}${BOLD}Usage : sh-rem modify <uuid> [-i <importance>] [-m <message>]${RESET}";;
        config)
            echo "${RED}${BOLD}Usage : sh-rem config <tag=value>${RESET}";;
        link)
            echo "${RED}${BOLD}Usage : sh-rem link <filepath>${RESET}";;
        check)
            echo "${RED}${BOLD}Usage : sh-rem check <uuid>${RESET}";;
        *) 
            helper;;
        esac
    else
        echo "add : Add value to the reminder with the wanted message and importance, if importance is not specified it will use the default value visible in the file"
        echo "list : List all the remiders or just the one from the specified importance"
        echo "del : Delete the remider with the specified uuid"
        echo "prune : Delete all the checked remiders from any or the specified importance"
        echo "modify : Modify the remider with the specified uuid using those options : -m <message> and -i <importance>"
        echo "check : Check the remider with the specified uuid"
        echo "link : Change the file to the one specified (NOT RECOMMENDED)"
        echo "config : Change the value of some of the main tags like : show to change the visibilty of list or the default value"
        echo "help : Show the helper"
    fi;
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
check) helper "check";;
prune) helper "prune";;
del) helper "del";;
config) helper "config";;
modify) helper "modify";;
link) helper "link";;
help) helper;;
*) helper;;
esac


exit

# echo -e "${BOLD}This text is bold.${RESET}"
# echo -e "${UNDERLINE}This text is underlined.${RESET}"
# echo -e "${REVERSE}This text has reverse colors.${RESET}"

# echo -e "${RED}${BOLD}This is red text.${RESET}"
# echo -e "${GREEN}This is green text.${RESET}"
# echo -e "${YELLOW}This is yellow text.${RESET}"