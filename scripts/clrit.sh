#! /bin/bash

Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

patterns=()
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
case $1 in
  -p|--pattern)
    IFS='|' read -r -a patterns <<< "$2"
    shift # move past argument
    shift # move past value
    ;;
  #--default)
  #  DEFAULT=YES
  #  shift
  #  ;;
  -*|--*)
    echo "Unknown argument $1 passed to clrit"
    exit 1
    ;;
  *)
    POSITIONAL_ARGS+=("$1") # save positional args
    shift
    ;;
esac
done

clrawk()
{
  echo "$*" | awk '
  BEGIN {
    IGNORECASE=1; # does not seem to work on mac

    nocolor="\033[0m";               # reset color
    colors[0]="\033[1;35m";          # reset color
    colors[1]="\033[1;36m";          # reset color
    colors[2]="\033[1;34m";          # reset color
    colors[3]="\033[1;33m";          # reset color
    colors[4]="\033[1;32m";          # reset color
    colors[5]="\033[43m\033[1;30m";  # reset color

    for (i=0; i < ARGC; i++)
      if(i > 0) patterns[i-1]=ARGV[i]
    for (i=0; i < ARGC; i++)
      if(i > 0) delete ARGV[i]
  }
  function println(code, line, nocode) {
    for (idx in patterns) {
      if(code) gsub(patterns[idx], colors[idx%6] patterns[idx] code, line)
      else gsub(patterns[idx], colors[idx%6] patterns[idx] nocolor, line)
    }
    print code line nocode
  }
  {
    err=match(tolower($0), /(error)|(fail)/);
    wrn=match(tolower($0), /(warn)/);
    if(err != 0){
      println("\033[0;31m", $0, "\033[0m");
    } else if(wrn != 0) {
      println("\033[0;33m", $0, "\033[0m");
    } else {
      println("", $0, "");
    }
  }' "${patterns[@]}"
}

# check to see if pipe exists on stdin
if [ -p /dev/stdin ]; then
  while IFS= read line; do
    clrawk "$line"
  done
else
  if [[ -f "${POSITIONAL_ARGS[0]}" ]]; then
    while IFS= read -r line; do
      clrawk "$line"
    done < "${POSITIONAL_ARGS[0]}"
  fi
fi