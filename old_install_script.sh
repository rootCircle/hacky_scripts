#! /usr/bin/bash

# Installs necessary packages for development in android, web, java, sqlite, mysql, Rust and other utils
sudo pacman -S python-pip ffmpegthumbs kio-extras libheif ninja cmake yarn nodejs npm nautilus drawing gscan2pdf gnome-system-monitor sqlitebrowser gnuchess gnome-chess arduino mari0 mysql-workbench jre17-openjdk discord cowsay banner bandwhich dust noto-fonts-emoji starship bluez bluez-utils libinput bridge-utils pitivi vim emacs neovim emacs rnote xournalpp clang gcc rustup ripgrep fd htop cheese kamoso scrcpy tldr kitty zsh fish alacritty qt5-imageformats kdegraphics-thumbnailers xclip deno fzf shellcheck nmap valgrind colordiff powertop gnome-sudoku blender calc gnome-sound-recorder
# waydroid/anbox is missing

#Exter
yay -S anbox-git touchegg-git touchegg libinput-gestures visual-studio-code-bin anaconda postman-bin whatsapp-for-linux flutter spotify processing eclipse-java mysql mycli gnirehtet-bin android-studio protonvpn webcamoid touchegg paru portmaster jpdftweak gnome-network-displays

paru -S ncurses5-compat-libs

# auto-cpufreq
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
sudo systemctl enable --now auto-cpufreq.service
sudo auto-cpufreq --install

sudo systemctl restart touchegg
git clone https://github.com/NayamAmarshe/ToucheggKDE.git
cd Touchegg*
mkdir ~/.config/touchegg
cp touch* ~/.config/touchegg/
systemctl enable --now touchegg
libinput-gestures-setup autostart
libinput-gestures-setup start
sudo gpasswd -a $USER input
git config --global --add safe.directory /opt/flutter
flatpak install flathub io.github.lainsce.Notejot

sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable portmaster.service
alias --save c clear

systemctl enable --now bluetooth.service

kvm-ok
flatpak install flathub com.obsproject.Studio
pamac update --force-refresh
flatpak install flathub org.onlyoffice.desktopeditors
sudo set -Ux fish_greeting
set -Ux fish_greeting
rustup default stable
rustup update
sudo gpasswd -a "${USER}" flutterusers


# Add github SSH
fish_add_path -g "/home/violow/.local/bin"

set -Ux OPENAI_API_KEY 'Open-ai-key-here'
alias --save ccr 'sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"sudo systemctl enable --now powertop.service .'
sudo nvim  /etc/systemd/system/powertop.service
sudo powertop -c

# Fix noise
