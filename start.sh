#!/bin/bash

# Define the requirements file
REQUIREMENTS="requirements.txt"

# Check if pip is installed
if ! command -v pip &> /dev/null; then
    echo "pip is not installed. Please install pip first."
    exit 1
fi

# Function to check if a package is installed
is_package_installed() {
    pip show "$1" &> /dev/null
}

# Read the requirements file line by line
if [ -f "$REQUIREMENTS" ]; then
    echo "Checking and installing dependencies..."
    while IFS= read -r package; do
        # Trim whitespace
        package=$(echo "$package" | xargs)
        # Skip empty lines or comments
        if [[ -z "$package" || "$package" == "#"* ]]; then
            continue
        fi
        # Check if the package is installed
        if is_package_installed "$package"; then
            echo "$package is already installed. Skipping..."
        else
            echo "$package is not installed. Installing..."
            pip install "$package"
        fi
    done < "$REQUIREMENTS"
else
    echo "Error: $REQUIREMENTS file not found."
    exit 1
fi

# Run the bot script
echo "Starting the bot..."
python bot.py
