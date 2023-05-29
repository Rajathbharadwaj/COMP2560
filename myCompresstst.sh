#!/bin/bash




size=0




# Help function to display script usage

display_help() {

echo "Usage: myCompress [-s size] [-p prog] <directory> <ext list>"

echo "Compresses files in the specified directory with extensions from the extension list."

echo "Options:"

echo "-s size: Only compress files larger than size bytes."

echo "-p prog: Use the specified program to compress files. If not provided, use xz."

exit 1

}




# Check if the required number of arguments are provided

if [[ $# -lt 2 ]]; then

echo "Error: Insufficient arguments."

display_help

exit 1

fi




while getopts "s:p:" option; do

case $option in

s)

size="$OPTARG"

 ;;

p)

prog="$OPTARG"

 ;;

\?)

echo "Invalid option" >&2

 display_help

 ;;

 esac

done




# Shift options out of arguments

shift $((OPTIND - 1))




# Get directory from next argument

directory="$1"




# Get extension list from next argument

extensionList="$2"




# Check if the directory exists

if [[ ! -d "$directory" ]]; then

echo "Invalid directory"

 exit 1

fi




# Check if any files matching the extension exist

if [[ ! $(find "$directory" -type f -name "*.$extensionList") ]]; then

echo "No files found matching the extension"

exit 1

fi




#compress files

if [[ -n "$prog" ]]; then

 if [[ "$size" -gt 0 ]]; then

find "$directory" -type f -name "*.$extensionList" -size +"$size"c | while read -r file; do

"$prog" "$file"

    done

 else

find "$directory" -type f -name "*.$extensionList" | while read -r file; do

 "$prog" "$file"

done

 fi

else

 if [[ "$size" -gt 0 ]]; then

find "$directory" -type f -name "*.$extensionList" -size +"$size"c | tar cJvf output.tar.xz -T -

else

find "$directory" -type f -name "*.$extensionList" | tar cJvf output.tar.xz -T -

 fi

fi