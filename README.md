# Dotfiles

## Table of Contents
- [1) Packages](#1-packages)
- [2) Pacman Customization](#2-pacman-customization)
- [3) Dev Environment](#3-dev-environment)
- [4) Install yay](#4-install-yay)
- [5) Copy Dotfiles](#5-copy-dotfiles)

---

## 1) Packages

### Pacman
```sh
sudo pacman -S --needed hyprpaper hyprpicker hyprlauncher hypridle hyprlock \
  xdg-desktop-portal-hyprland hyprsunset hyprpolkitagent hyprpwcenter hyprtoolkit \
  hyprcursor hyprutils hyprlang hyprwayland-scanner aquamarine hyprgraphics \
  hyprland-guiutils zsh fastfetch dosfstools dysk man-db man-pages wl-clipboard \
  htop unzip libsecret celluloid vim nerd-fonts steam gamescope discord \
  libreoffice-still ghostty acpi imagemagick ghostscript tectonic \
  power-profiles-daemon noto-fonts flatpak nwg-look
```

### AUR (yay)
```sh
yay -S --needed brave-bin adwaita-qt5 adwaita-qt6 bibata-cursor-theme \
  protonup-qt python-inputs python-steam hyprsysteminfo hyprshutdown hyprqt6engine
```

### Flatpaks
- Postman
- pgAdmin 4

### Oh-My-Zsh
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Shell
```sh
chsh -s /bin/zsh
```

### Zsh Plugins
Install the following plugins:
- [powerlevel10k](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#installation)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)

Then add them to your `.zshrc`:
```sh
plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
)
ZSH_THEME="powerlevel10k/powerlevel10k"
```

### Neovim
See the [Neovim README](Config/nvim/README.md) for the full LazyVim setup, including the one-liner dependency installer for macOS, Arch, Ubuntu, and Raspberry Pi OS.

---

## 2) Pacman Customization

1. Open the config: `vim /etc/pacman.conf`
2. Under the **Misc options** section, uncomment `Color` and `ParallelDownloads`
3. Add `ILoveCandy` to the bottom of the Misc options section

---

## 3) Dev Environment

### Node.js
Install Node.js manually from the [Node.js website](https://nodejs.org/), then install global npm packages:
```sh
npm install -g neovim @mermaid-js/mermaid-cli
```

### Python
```sh
pip install pynvim
```

### Neovim
See the [Neovim README](https://github.com/Ramen96/dotfiles/blob/main/Config/nvim/README.md) for the full LazyVim setup, including the one-liner dependency installer for macOS, Arch, Ubuntu, and Raspberry Pi OS.

---

## 4) Install yay

```sh
sudo pacman -Syu
sudo pacman -S git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
```

---

## 5) Copy Dotfiles

```sh
git clone https://github.com/Ramen96/dotfiles.git
mkdir -p ~/.config/
cd dotfiles/Config/
cp -rv ./* ~/.config/
```
