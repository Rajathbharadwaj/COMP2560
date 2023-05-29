#!/bin/bash

# Function to display help message
display_help() {
    echo "Usage: myCompress [-s size] [-p prog] <directory> <ext.list>"
    echo "Compresses files in the specified directory with extensions from the extension list."
    echo ""
    echo "Options:"
    echo "  -s size   Only compress files larger than size bytes."
    echo "  -p prog   Use the specified program to compress files."
    echo ""
    echo "Examples:"
    echo "  myCompress -p gzip ./ ps pdf"
    echo "  myCompress ./files/letters doc pdf"
    echo "  myCompress -p gzip -s 10000 ./ doc pdf ps"
    echo ""
    exit 1
}

# Check if the required arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Error: Missing directory or extension list."
    display_help
fi

# Default values for options
size=0
prog="xz"

# Parse the command line arguments
while getopts "s:p:" opt; do
    case $opt in
        s) size="$OPTARG" ;;
        p) prog="$OPTARG" ;;
        \?) echo "Invalid option: -$OPTARG" >&2
            display_help ;;
    esac
done

# Shift the parsed options out of the arguments
shift $((OPTIND - 1))

# Get the directory and extension list from the remaining arguments
directory="$1"
ext_list="$2"

# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "Error: Directory '$directory' does not exist."
    exit 1
fi

# Check if the extension list file exists
echo $directory
echo $ext_list


if [[ ! $(find "$directory" -type f -name "*.$ext_list") ]]; then
echo "No files found matching the extension"
exit 1
fi

# Compress the files based on the provided options
while IFS= read -r file; do
    file_size=$(stat -c %s "$file")
    if [ "$file_size" -gt "$size" ]; then
        $prog "$file"
    fi
done < <(find "$directory" -type f -name "*.*" | grep -f "$ext_list")
