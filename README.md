<div align="center">

<img src="https://raw.githubusercontent.com/hyprwm/Hyprland/main/assets/header.svg" alt="Hyprland" width="600" style="border-radius: 12px;" />

# 🏔️ Dotfiles

**A hand-crafted configuration for Arch Linux + Hyprland**

*Minimal. Fast. Yours.*

[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)](https://archlinux.org/)
[![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?style=for-the-badge&logo=wayland&logoColor=black)](https://hyprland.org/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

</div>

---

> [!IMPORTANT]
> These dotfiles are built **exclusively for Arch Linux with Hyprland** on Wayland. They will not work on X11, other distros without modification, or other window managers.

---

## 📋 Table of Contents

- [⚡ Auto Install](#-auto-install)
- [🔨 Manual Install](#-manual-install)
  - [📦 Packages](#-packages)
  - [🎨 Pacman Customization](#-pacman-customization)
  - [🛠️ Dev Environment](#️-dev-environment)
  - [🔧 Install yay](#-install-yay)
  - [📁 Copy Dotfiles](#-copy-dotfiles)

---

## ⚡ Auto Install

> [!WARNING]
> The auto installer will modify your system, install packages, and overwrite existing configs in `~/.config`. Review the [install.sh](install.sh) script before running it.

One command to set everything up — packages, AUR, Flatpaks, Oh-My-Zsh, plugins, dotfiles, and Neovim:

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/Ramen96/dotfiles/main/install.sh)
```

> [!NOTE]
> Node.js must be installed manually from [nodejs.org](https://nodejs.org/) before running the installer if you want the npm globals (`neovim`, `mermaid-cli`) set up automatically. The script will skip that step and remind you if Node isn't found.

---

## 🔨 Manual Install

Prefer to do things yourself? Follow the steps below in order.

---

## 📦 Packages

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

> [!NOTE]
> Install `yay` first — see [Install yay](#-install-yay) below.

```sh
yay -S --needed brave-bin adwaita-qt5 adwaita-qt6 bibata-cursor-theme \
  protonup-qt python-inputs python-steam hyprsysteminfo hyprshutdown hyprqt6engine
```

### Flatpaks

| App | Purpose |
|-----|---------|
| **Postman** | API development & testing |
| **pgAdmin 4** | PostgreSQL database manager |

### Oh-My-Zsh

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Then set Zsh as your default shell:

```sh
chsh -s /bin/zsh
```

### Zsh Plugins

Install the following plugins manually:

- [powerlevel10k](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#installation) — feature-rich prompt theme
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md) — fish-like command suggestions
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md) — real-time syntax coloring

Then register them in your `.zshrc`:

```sh
plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
)

ZSH_THEME="powerlevel10k/powerlevel10k"
```

### Neovim

See the [Neovim README](Config/nvim/README.md) for the full LazyVim setup, including a one-liner dependency installer for macOS, Arch, Ubuntu, and Raspberry Pi OS.

---

## 🎨 Pacman Customization

Give pacman a glow-up with colors, parallel downloads, and the legendary candy progress bar.

1. Open the config:
   ```sh
   sudo vim /etc/pacman.conf
   ```

2. Under the **`[options]`** section, uncomment:
   ```ini
   Color
   ParallelDownloads = 5
   ```

3. Add the fun stuff directly below:
   ```ini
   ILoveCandy
   ```

---

## 🛠️ Dev Environment

### Node.js

Install Node.js from the [official website](https://nodejs.org/), then grab global packages:

```sh
npm install -g neovim @mermaid-js/mermaid-cli
```

### Python

```sh
pip install pynvim
```

### Neovim

See the [Neovim README](https://github.com/Ramen96/dotfiles/blob/main/Config/nvim/README.md) for the full LazyVim setup, including a one-liner dependency installer for macOS, Arch, Ubuntu, and Raspberry Pi OS.

---

## 🔧 Install yay

`yay` is an AUR helper built on top of pacman. Install it first before running any `yay` commands.

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

## 📁 Copy Dotfiles

Clone the repo and drop the configs into `~/.config`:

```sh
git clone https://github.com/Ramen96/dotfiles.git
mkdir -p ~/.config/
cd dotfiles/Config/
cp -rv ./* ~/.config/
```

---

<div align="center">

Made with ❤️ on Arch Linux

</div>
