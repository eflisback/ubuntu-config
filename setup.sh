#!/bin/bash

# Repository
echo "Cloning repository..."
git clone git@github.com:eflisback/ubuntu-config.git ~/ubuntu-config

echo "Updating package list... (logs available in ~/ubuntu-setup/apt-log.txt)"
sudo apt update -y &>~/ubuntu-setup/apt-log.txt && sudo apt upgrade -y &>~/ubuntu-setup/apt-log.txt

touch ~/ubuntu-setup/apt-log.txt

packages=(
    "i3"
    "i3lock"
    "zsh"
    "alacritty"
    "picom"
)

echo "Installing packages..."
for package in "${packages[@]}"; do
    sudo apt install "$package" -y &>~/ubuntu-setup/apt-log.txt
    echo "--- $package installed ---"
done

declare -A configuration_files=(
    ["i3"]="~/ubuntu-config/i3/config ~/.config/i3/config"
    ["zsh"]="~/ubuntu-config/zsh/.zshrc ~/.zshrc"
    ["alacritty"]="~/ubuntu-config/alacritty/.alacritty.toml ~/.config/alacritty/alacritty.toml"
)

for name in "${!configuration_files[@]}"; do
    paths=(${configuration_files[$name]})
    src=${paths[0]}
    dest=${paths[1]}

    mkdir -p $(dirname "$dest")
    ln -s "$src" "$dest"

    echo "--- $name successfully linked to $dest ---"
done

pictures=(
    "ubuntu.jpg"
    "lock-screen.jpg"
)

for picture in "${pictures[@]}"; do
    ln -s "~/ubuntu-config/pictures/$picture" "~/Pictures/$picture"
    echo "--- $picture linked to ~/Pictures/$picture ---"
done

echo "Set-up complete"
