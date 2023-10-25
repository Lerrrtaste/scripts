#!/usr/bin/env sh

# Ask the user for the desired module
echo "Enter the module name to filter:"
read module_name

# Check if the module_name is empty, if so exit
if [ -z "$module_name" ]; then
    echo "No module name provided, exiting."
    exit 1
fi

# Create or overwrite the output file
> output.txt

# Set a flag to indicate if the current line belongs to the filtered module
in_module=0

# Read the input.txt line by line
while IFS= read -r line; do
    # Check if the line starts with "KW" (calendar week) and reset the in_module flag
    if [[ $line == KW* ]]; then
        in_module=0
        # Write the calendar week header to output.txt
        # echo "$line" >> output.txt
    elif [[ $line == *"$module_name"* ]]; then
        # The current line belongs to the desired module
        in_module=1
    else
        in_module=0
    fi   # If the in_module flag is set, write the line to output.txt
    if [ "$in_module" -eq 1 ]; then
        echo "$line" >> output.txt
    fi
done < input.txt

echo "Filtered events saved to output.txt."
