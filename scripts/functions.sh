#!/bin/bash

# functions.sh
# common functions

#colors
CMD_COLOR="\033[38;5;0;48;5;226m"
CMD_COLOR2="\033[38;5;35m"
#CMD_COLOR2="\033[38;5;0;48;5;35m"
PAUSE_COLOR="\033[38;5;165;48;5;255m"
RST_COLOR="\033[m"

function pause() {
  printf "$PAUSE_COLOR"
  read -n1 -s -p "Press SPACE" a
  #echo -en "\r"
  rst
}

function rst() {
  printf "\r"
  printf "$RST_COLOR"
  printf "            \n"
}

function cmd_banner() {
  CMD="$@"
  printf "$CMD_COLOR"
  printf "cmd:$RST_COLOR "
  printf "$CMD_COLOR2"
  printf "$CMD\n"
  printf "$RST_COLOR"
}

function execute_array() {
  CMD_ARRAY=$@
  for ((i = 0; i < ${#CMD_ARRAY[@]}; i++)); do
    cmd_banner "${CMD_ARRAY[i]}"
    bash -c "${CMD_ARRAY[i]}"
    pause
  done
}

function ctrl_c() {
  rst
  exit 1
}

trap ctrl_c INT
