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

ARROW='\u2192'

# FILE_NAME='.sh-rem-data.yaml' #default .sh-rem-data.yaml
FILE_NAME="$HOME/.sh-rem-data.yaml"

checkRemider(){
    echo "TODO"
}

initStorageFile(){
    touch "$FILE_NAME"
    echo "show: true
default: 3
importance_number: 5
I1:
I2:
I3:
I4:
I5:" > $FILE_NAME
}

addValue(){ # Message  [Importance] default 3
    new_uuid=$(uuidgen)
    if [ $# -eq 1 ]; then
        default_value=$(yq '.default' $FILE_NAME)
        yq eval ".I$default_value += [{\"$new_uuid\": [\"$1\",{\"checked\": false}]}]" $FILE_NAME -i
    else
        yq eval ".I$2 += [{\"$new_uuid\": [\"$1\",{\"checked\": false}]}]" $FILE_NAME -i
    fi;
}

printValues(){

    if [ $# -eq 1 ]; then
        #GREP SPECIFIC IMPORTANCE

        uuids=$(yq ".I${1}[] | keys | .[]" "$FILE_NAME")
        values=$(yq eval ".I${1}[].[][0]" "$FILE_NAME")
        checked=$(yq eval ".I${1}[].[][][]" "$FILE_NAME")  

        echo "${RED}${REVERSE} REMIDER LVL${1} : ${RESET}"

        for j in {1..$(wc -l <<< $uuids)}; do

            ISCHECKED=$(sed -n "${j}p" <<< $checked)
            ISVALUE=$(sed -n "${j}p" <<< $values)
            ISUUID=$(sed -n "${j}p" <<< $uuids)

            if [ "$ISCHECKED" = "false" ]; then
                echo "${YELLOW} ${UNCHECKED} - ${ISVALUE} ${RESET} ${ARROW} ${ISUUID}"
            else
                echo "${YELLOW} ${CHECKED} - ${ISVALUE} ${RESET} ${ARROW} ${ISUUID}"
            fi;
        done
        echo ""   

    else
        #GREP ALL IMPORTANCES
        max_value=$(yq '.importance_number' $FILE_NAME)
        for i in {1..$max_value}; do
            uuids=$(yq ".I${i}[] | keys | .[]" "$FILE_NAME")
            values=$(yq eval ".I${i}[].[][0]" "$FILE_NAME")
            checked=$(yq eval ".I${i}[].[][][]" "$FILE_NAME")

            if [ "$uuids" = "" ]; then
                continue;
            fi;
        
            echo "${RED}${REVERSE} REMIDER LVL${i} : ${RESET}"

            for j in {1..$(wc -l <<< $uuids)}; do

                ISCHECKED=$(sed -n "${j}p" <<< $checked)
                ISVALUE=$(sed -n "${j}p" <<< $values)
                ISUUID=$(sed -n "${j}p" <<< $uuids)

                if [ "$ISCHECKED" = "false" ]; then
                    echo "${YELLOW} ${UNCHECKED} - ${ISVALUE} ${RESET} ${ARROW} ${ISUUID}"
                else
                    echo "${YELLOW} ${CHECKED} - ${ISVALUE} ${RESET} ${ARROW} ${ISUUID}"
                fi;
            done
            echo ""
        done
    fi; 

}

helper(){
    
    if [ $# -eq 1 ]; then
        case "$1" in
        add) 
            default_value=$(yq '.default' $FILE_NAME)
            echo "${RED}${BOLD}Usage : sh-rem add <message> [importance default=${default_value}]${RESET}";;
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
        init)
            echo "${RED}${BOLD}Usage: sh-rem init${RESET} -> Necessary in order to use the program";;
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
        echo "init : Initialize a good storage file"
        echo "help : Show the helper"
    fi;
    exit
}

if ! [ -e "$FILE_NAME" ]; then
    echo "${RED}${BOLD}FILE NOT FOUND : ${RESET}FILE INITIALIZATION"
    initStorageFile
    exit
fi;

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
check)
    if [ $# -eq 2 ]; then
        checkRemider $2
    else
        helper "check"
    fi;;
prune) helper "prune";;
del) helper "del";;
config) helper "config";;
modify) helper "modify";;
link) helper "link";;
init) 
    if [ $# -eq 1 ]; then
        initStorageFile
    else
        helper "init"
    fi;;
help) helper;;
*) helper;;
esac


exit