#!/bin/bash
set -euo pipefail

if ! command -v code &> /dev/null; then
    echo "Error: 'code' command not found. Please ensure Visual Studio Code is installed and in your PATH."
    exit 1
fi

if [ ! -f "./settings.json" ] || [ ! -f "./keybindings.json" ] || [ ! -f "./vscode-extensions.txt" ]; then
    echo "Error: settings.json, keybindings.json, or vscode-extensions.txt not found in the current working directory!"
    exit 1
fi

mkdir -p ~/.config/Code/User

echo "Copying settings.json to ~/.config/Code/User/settings.json"
cp ./settings.json ~/.config/Code/User/settings.json 

echo "Copying keybindings.json to ~/.config/Code/User/keybindings.json"
cp ./keybindings.json ~/.config/Code/User/keybindings.json

echo "Installing extensions from ./vscode-extensions.txt"

# Install each extension listed in the file
while IFS= read -r extension || [[ -n "$extension" ]]; do
    if [[ -n "$extension" && ! "$extension" =~ ^# ]]; then
        echo "Installing extension: $extension"
        code --install-extension "$extension"
        if [ $? -ne 0 ]; then
            echo "Failed to install: $extension"
        fi
    fi
done < "./vscode-extensions.txt"

echo "Extensions installed successfully."
