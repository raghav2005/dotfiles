#!/bin/bash

DOTFILES_DIR=~/github_repos/dotfiles
TARGET_DIR=~/

# loop through each file in the dotfiles directory, including hidden files
for item in "$DOTFILES_DIR"/.* "$DOTFILES_DIR"/*; do
    # get the base name of the file (e.g., .zshrc, .bashrc)
    basename=$(basename "$item")

    # skip files and directories we want to ignore
    if [[ "$basename" == "." || "$basename" == ".." || "$basename" == ".gitignore" || \
          "$basename" == "README.md" || "$basename" == ".git" || \
          "$basename" == ".gitmodules" || "$basename" == "sync_dotfiles.sh" ]]; then
        continue
    fi
    
    # create a symbolic link in the target directory
    ln -sf "$item" "$TARGET_DIR/$basename"
done

# ensure echo is output on a new line and directed to the terminal
echo -e "\ndotfiles synced!" > /dev/tty
