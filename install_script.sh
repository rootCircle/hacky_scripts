#!/usr/bin/env bash

# TODO : MySQL + Workbench setup using mariadb

# Last updated : 10-05-2023 2:00 IST

# Packages installed using pacman, some might not be useful per use case
#  libfuse kdegraphcs-thumbnailers qemu-kvm libvirt-daemon-system libvirt-clients
sudo pacman -S time pdftk lib32-gcc-libs blender lynx calc gnome-sudoku qt5-imageformats kdegraphics-thumbnailers xclip deno fzf shellcheck nmap valgrind colordiff dust python-pip ffmpegthumbs ffmpegthumbs kio-extras libheif ninja cmake yarn nodejs npm drawing gscan2pdf gnome-system-monitor sqlitebrowser gnuchess arduino mari0 mysql-workbench jre17-openjdk discord  gnome-chess cowsay banner bandwhich noto-fonts-emoji starship bluez bluez-utils libinput-gestures libinput bridge-utils pitivi vim neovim emacs rnote xournalpp clang gcc rustup ripgrep fd htop cheese kamoso scrcpy tldr kitty zsh fish alacritty festival festival-english festival-us docker kgpg pyenv paru jdk17-openjdk powertop

# Packages installed using yay
# Missing : anbox, waydroid
yay -S libcs50 gnome-network-displays-git jpdftweak tgpt touche touchegg-git libinput-gestures visual-studio-code-bin anaconda postman-bin whatsapp-for-linux flutter spotify processing eclipse-java eclipse-ide mysql mycli Gnirehtet android-studio protonvpn webcamoid

# Packages installed using paru
# ncurses5-compat-libs is required only for xilinx
paru -S ncurses5-compat-libs portmaster-stub-bin envycontrol

# Flatpak repos
flatpak install flathub org.onlyoffice.desktopeditors
flatpak install flathub com.obsproject.Studio
flatpak install flathub io.github.lainsce.Notejot


# Only for nautilus installed in KDE to disable File History
enable=0
if [ $enable -eq 1 ]; then
	rm ~/.local/share/recently-used.xbel
	touch ~/.local/share/recently-used.xbel
	sudo chattr +i ~/.local/share/recently-used.xbel
fi

# Add .local/bin to PATH by editing ~/.config/fish/config.fish
fish_add_path -g "/home/$USER/.local/bin"

# Enable experimental features to enable showing bluetooth battery percentage in KDE
# Changes to be done can be found in arch wikis
# https://wiki.archlinux.org/title/Bluetooth#Enabling_experimental_features
sudo nvim /usr/lib/systemd/system/bluetooth.service
sudo nvim /etc/bluetooth/main.conf
sudo systemctl restart bluetooth.service
sudo systemctl daemon-reload

# Set up Github SSH keys, modify NAME AND EMAIL before accessing

NAME="JOHN"
EMAIL="user1@example.org"
git config --global --add user.name $NAME
git config --global --add user.email $EMAIL
ssh-keygen -t ed25519 -C $EMAIL
eval "$(ssh-agent -s)" > ssh_key.txt
ssh-add ~/.ssh/id_ed25519
ssh -T git@github.com
echo "SSH key saved at $(pwd)/ssh_key.txt"
echo "Delete after Use!!!"

# Set up flutter install
sudo gpasswd -a ${USER} flutterusers

# Installing auto-cpufreq, AUR is kinda not preffered
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq
sudo ./auto-cpufreq-installer
sudo auto-cpufreq --install
rm -rf auto-cpufreq

# Valgrind may not work and will requires ncurses5-compat-libs present in AUR


# OPEN_AI_KEY
key="sk-OPEN_AI_KEY_HERE"
set -Ux OPENAI_API_KEY $key

# Make initial fish welcome message disappear
sudo set -Ux fish_greeting
set -Ux fish_greeting

# Initialising Rustup
rustup default stable

# Flutter fixes
git config --global --add safe.directory /opt/flutter

# For ProtonVPN app indicator
sudo pacman -Syu libappindicator-gtk3 gnome-shell-extension-appindicator

# Install GRUB theme

# Enabling the services [Bluetooth won't work without it]
sudo systemctl enable --now portmaster.service
sudo systemctl enable --now bluetooth.service

# MySQL install setup
sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# Setting different conda environment
cd ~
cp .bashrc .conda.bashrc
nvim .conda.bashrc

echo '\nsource /opt/anaconda/bin/activate root' >> .conda.bashrc

# Enabling Multi Touch Gesture Support for KDE
sudo gpasswd -a $USER input
libinput-gestures-setup start
libinput-gestures-setup autostart
systemctl enable --now touchegg
git clone https://github.com/NayamAmarshe/ToucheggKDE.git
cd Touchegg*
mkdir ~/.config/touchegg
cp touch* ~/.config/touchegg/
sudo systemctl restart touchegg
# TIP : Use touche to modify gestures

# Xilinx setup after install using ./xsetup
cp ~/.bashrc ~/.xilinxbashrc
echo "\nsource /opt/Xilinx/12.4/ISE_DS/settings64.sh" >> ~/.xilinxbashrc

# Constraining the battery charge threshold to improve battery health
# Type below text to `/etc/systemd/system/battery-charge-threshold.service` in sudo

[Unit]
Description=Set the battery charge threshold
After=multi-user.target
StartLimitBurst=0

[Service]
Type=oneshot
Restart=on-failure
ExecStart=/bin/bash -c 'echo 90 > /sys/class/power_supply/BAT0/charge_control_end_threshold'

[Install]
WantedBy=multi-user.target
# END OF TEXT HERE
sudo systemctl enable --now battery-charge-threshold.service




# Powertop setup
# Write below text in `/etc/systemd/system/powertop.service` in sudo mode

[Unit]
Description=Powertop tunings

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/powertop --auto-tune

[Install]
WantedBy=multi-user.target

# END OF TEXT
sudo systemctl enable --now powertop.service
sudo powertop --auto-tune
sudo powertop --calibrate

# Docker Setup
systemctl start docker
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Coqui AI tts [~10 GB in size] Requires docker
# docker run --rm -it -p 5002:5002 --entrypoint /bin/bash ghcr.io/coqui-ai/tts-cpu



# ZSH customization
curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
# Then open ~/.zimrc and add `zmodule prompt-pwd` and `zmodule eriner` at end to apply theme

# System Variables in Fish for better `make`
set -Ux CC /usr/bin/clang
set -Ux CFLAGS "-fsanitize=integer -fsanitize=undefined -ferror-limit=1 -gdwarf-4 -ggdb3 -O0 -std=c11 -Wall -Werror -Wextra -Wno-gnu-folding-constant -Wno-sign-compare -Wno-unused-parameter -Wno-unused-variable -Wshadow"
set -Ux LDLIBS "-lcrypt -lcs50 -lm"
set -Ux CXX /usr/bin/clang++
set -Ux CXXFLAGS "-fsanitize=integer -fsanitize=undefined -ferror-limit=1 -gdwarf-4 -ggdb3 -O0 -Wall -Werror -Wextra -Wno-gnu-folding-constant -Wno-sign-compare -Wno-unused-parameter -Wno-unused-variable -Wshadow"


# Aliases (Some need pre-configurations)
alias --save act_conda 'bash --rcfile ~/.conda.bashrc'
alias --save c clear
alias --save ccr 'sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"'
alias --save revtet gnirehtet
alias --save valgrind 'valgrind --leak-check=full -s --show-leak-kinds=all'
alias --save update 'sudo sh -c "cowsay pacman; pacman -Syu; cowsay flatpak; flatpak update;"; cowsay paru; paru -Syu'

# To remove an alias in fish
functions -e <NAME>
rm ~/.config/fish/function/<NAME>.fish

# To update GRUB use 
sudo grub-mkconfig -o /boot/grub/grub.cfg

# To change the GPU usage
sudo envycontrol -s [integrated, hybrid, nvidia]

# UTF8 support in Konsole
locale -a | grep -i UTF
echo "Choose one of them as store overwrite them in below variable"
_LOCALE = "en_IN.utf8"
set -Ux LANG $_LOCALE
set -gx LANG $_LOCALE


