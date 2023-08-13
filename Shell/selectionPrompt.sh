
#!/bin/bash

# Global Vars
esc=$(printf "\033" ) # cashe esc key

# Clean up
function cleanup() {
 tput cnorm # restore cursor
}

trap cleanup EXIT

#############################################################################
# Takes in two parameters 
# @param1: empty variable to capture chosen value
# @param2: a list of string containing a series of option for display and choosing
# User can navigate between displayed options using UP or DOWN ARROW-KEY and make a selection by pressing ENTER
function selectOptions ()
{
  local options=("${@:2}")
  local count=${#options[@]}
  local curSelection=''
  local curSelectionIndex=0
  tput civis # hide cursor
  while true
  do
    # print all options
    index=0 
    for o in "${options[@]}"
    do
      if [ "$index" == "$curSelectionIndex" ]
      then printf " >\e[7m$o\e[0m\n" # mark & highlight the current option
      else printf "  $o\n"
      fi
      index=$(( $index + 1 ))
    done
    printf "\e[${count}A" # go up to the beginning to re-render
    read -s -n3 key # wait for user to key in arrows or ENTER
    if [[ "$key" == "$esc[A" ]] # up arrow
    then
      curSelectionIndex=$(( $curSelectionIndex - 1 ))
      [ "$curSelectionIndex" -lt 0 ] && curSelectionIndex=0
    elif [[ "$key" == "$esc[B" ]] # down arrow
    then 
      curSelectionIndex=$(( $curSelectionIndex + 1 ))
      [ "$curSelectionIndex" -ge $count ] && curSelectionIndex=$(( $count- 1 ))
    elif [[ $key == "" ]] # nothing, i.e the read delimiter - ENTER
    then
      # remove unrequired info from console 
        printf "\e[0K"  # TODO somehow not working for release selection
      # assign return value
      eval "$1='${options[$curSelectionIndex]}'"
      break
    fi
  done
}

#############################################################################
# Sample Main Flow
# Sample-1 Choose environment
printf "\e[1mWhich environment you wish to use?\e[22m\n"
envOptions=("staging" "development")
selectOptions chosenEnv "${envOptions[@]}"
printf "\e[1A\e[49C"  # move cusor
printf "\e[96;49;m($chosenEnv)\n\e[39;49;m"
# Display release for user to pick from
printf "\e[1mWhich option you would like to choose?\e[22m\n"
sampleOptions=("This is: Option1" "This is: Option2" "This is: Option3" "This is: Option3")
selectOptions chosenOption "${sampleOptions[@]}"
printf "\e[1A\e[49C"  # move cusor
printf "\e[96;49;m($chosenOption)\n\e[39;49;m"
# Happy exit
exit 0
