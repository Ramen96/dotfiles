#!/usr/bin/env bash
# =============================================================================
#  Dotfiles Installer — Arch Linux + Hyprland
#  https://github.com/Ramen96/dotfiles
# =============================================================================

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
RESET='\033[0m'
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
DIM='\033[2m'

# ── Helpers ───────────────────────────────────────────────────────────────────
info() { echo -e "${CYAN}${BOLD}  --> ${RESET}${BOLD}$*${RESET}"; }
success() { echo -e "${GREEN}${BOLD}  ✔   $*${RESET}"; }
warn() { echo -e "${YELLOW}${BOLD}  ⚠   $*${RESET}"; }
error() {
  echo -e "${RED}${BOLD}  ✘   $*${RESET}" >&2
  exit 1
}
dim() { echo -e "${DIM}      $*${RESET}"; }

section() {
  echo -e "\n${BOLD}${CYAN}━━━  $*${RESET}"
  echo -e "${DIM}      ────────────────────────────────────────────${RESET}\n"
}

confirm() {
  local prompt="$1"
  local response
  echo -en "${YELLOW}${BOLD}  ?   ${RESET}${BOLD}${prompt} ${DIM}[y/N]${RESET} "
  read -r response
  [[ "$response" =~ ^[Yy]$ ]]
}

# ── Sanity checks ─────────────────────────────────────────────────────────────
if [[ $EUID -eq 0 ]]; then
  error "Do not run this script as root. It will use sudo where needed."
fi

if ! command -v pacman &>/dev/null; then
  error "This script is for Arch Linux only (pacman not found)."
fi

# ── Banner ────────────────────────────────────────────────────────────────────
echo -e "
${CYAN}${BOLD}
   ██████╗  ██████╗ ████████╗███████╗██╗██╗      ███████╗███████╗
   ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║      ██╔════╝██╔════╝
   ██║  ██║██║   ██║   ██║   █████╗  ██║██║      █████╗  ███████╗
   ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║      ██╔══╝  ╚════██║
   ██████╔╝╚██████╔╝   ██║   ██║      ██║███████╗███████╗███████║
   ╚═════╝  ╚═════╝    ╚═╝   ╚═╝      ╚═╝╚══════╝╚══════╝╚══════╝
${RESET}
   ${DIM}Arch Linux + Hyprland — by Ramen96${RESET}
   ${DIM}https://github.com/Ramen96/dotfiles${RESET}
"

echo -e "${YELLOW}${BOLD}  This script will:${RESET}"
dim "1.  Update your system"
dim "2.  Install pacman packages"
dim "3.  Configure pacman (Color, ParallelDownloads, ILoveCandy)"
dim "4.  Install yay (AUR helper)"
dim "5.  Install AUR packages"
dim "6.  Install Flatpak apps"
dim "7.  Install Oh-My-Zsh + plugins"
dim "8.  Set Zsh as default shell"
dim "9.  Install Node.js global packages"
dim "10. Install Python packages"
dim "11. Back up existing ~/.config and copy dotfiles"
dim "12. Run the Neovim setup script"
echo ""

if ! confirm "Ready to begin?"; then
  echo -e "\n${DIM}  Aborted.${RESET}\n"
  exit 0
fi

# ─────────────────────────────────────────────────────────────────────────────
section "1 · System Update"
# ─────────────────────────────────────────────────────────────────────────────
info "Running full system upgrade..."
sudo pacman -Syu --noconfirm
success "System up to date"

# ─────────────────────────────────────────────────────────────────────────────
section "2 · Pacman Packages"
# ─────────────────────────────────────────────────────────────────────────────
info "Installing pacman packages..."
sudo pacman -S --needed --noconfirm \
  hyprpaper hyprpicker hyprlauncher hypridle hyprlock \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk hyprsunset hyprpolkitagent hyprpwcenter hyprtoolkit \
  hyprcursor hyprutils hyprlang hyprwayland-scanner aquamarine hyprgraphics \
  hyprland-guiutils zsh fastfetch dosfstools dysk man-db man-pages wl-clipboard \
  htop unzip libsecret celluloid vim nerd-fonts steam gamescope discord \
  libreoffice-still ghostty acpi imagemagick ghostscript tectonic \
  power-profiles-daemon noto-fonts flatpak nwg-look \
  git base-devel curl
success "Pacman packages installed"

# ─────────────────────────────────────────────────────────────────────────────
section "3 · Pacman Configuration"
# ─────────────────────────────────────────────────────────────────────────────
info "Configuring /etc/pacman.conf..."

PACMAN_CONF="/etc/pacman.conf"

if grep -q "^#Color" "$PACMAN_CONF"; then
  sudo sed -i 's/^#Color/Color/' "$PACMAN_CONF"
  dim "Enabled: Color"
else
  dim "Already set: Color"
fi

if grep -q "^#ParallelDownloads" "$PACMAN_CONF"; then
  sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 5/' "$PACMAN_CONF"
  dim "Enabled: ParallelDownloads = 5"
else
  dim "Already set: ParallelDownloads"
fi

if ! grep -q "^ILoveCandy" "$PACMAN_CONF"; then
  sudo sed -i '/^ParallelDownloads/a ILoveCandy' "$PACMAN_CONF"
  dim "Added: ILoveCandy"
else
  dim "Already set: ILoveCandy"
fi

success "pacman.conf configured"

# ─────────────────────────────────────────────────────────────────────────────
section "4 · Install yay (AUR Helper)"
# ─────────────────────────────────────────────────────────────────────────────
if command -v yay &>/dev/null; then
  warn "yay is already installed — skipping"
else
  info "Cloning and building yay..."
  YAY_TMP=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$YAY_TMP/yay"
  pushd "$YAY_TMP/yay" >/dev/null
  makepkg -si --noconfirm
  popd >/dev/null
  rm -rf "$YAY_TMP"
  success "yay installed"
fi

# ─────────────────────────────────────────────────────────────────────────────
section "5 · AUR Packages"
# ─────────────────────────────────────────────────────────────────────────────
info "Installing AUR packages via yay..."
yay -S --needed --noconfirm \
  brave-bin adwaita-qt5 adwaita-qt6 bibata-cursor-theme \
  protonup-qt python-inputs python-steam hyprsysteminfo hyprshutdown hyprqt6engine
success "AUR packages installed"

# ─────────────────────────────────────────────────────────────────────────────
section "6 · Flatpak Apps"
# ─────────────────────────────────────────────────────────────────────────────
info "Adding Flathub remote..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

info "Installing Postman..."
flatpak install -y flathub com.getpostman.Postman

info "Installing pgAdmin 4..."
flatpak install -y flathub io.pgadmin.pgadmin4

success "Flatpak apps installed"

# ─────────────────────────────────────────────────────────────────────────────
section "7 · Oh-My-Zsh + Plugins"
# ─────────────────────────────────────────────────────────────────────────────
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  warn "Oh-My-Zsh already installed — skipping"
else
  info "Installing Oh-My-Zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  success "Oh-My-Zsh installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

info "Installing powerlevel10k..."
if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k"
  success "powerlevel10k installed"
else
  dim "powerlevel10k already present — skipping"
fi

info "Installing zsh-autosuggestions..."
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  success "zsh-autosuggestions installed"
else
  dim "zsh-autosuggestions already present — skipping"
fi

info "Installing zsh-syntax-highlighting..."
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  success "zsh-syntax-highlighting installed"
else
  dim "zsh-syntax-highlighting already present — skipping"
fi

# ─────────────────────────────────────────────────────────────────────────────
section "8 · Default Shell → Zsh"
# ─────────────────────────────────────────────────────────────────────────────
if [[ "$SHELL" == "/bin/zsh" ]]; then
  warn "Zsh is already the default shell — skipping"
else
  info "Changing default shell to Zsh..."
  chsh -s /bin/zsh
  success "Default shell set to /bin/zsh (takes effect on next login)"
fi

# ─────────────────────────────────────────────────────────────────────────────
section "9 · Node.js Global Packages"
# ─────────────────────────────────────────────────────────────────────────────
if ! command -v node &>/dev/null; then
  warn "Node.js not found — skipping npm globals."
  warn "Install Node.js from https://nodejs.org/ then run:"
  dim "  npm install -g neovim @mermaid-js/mermaid-cli"
  NODE_MISSING=true
else
  info "Installing global npm packages..."
  npm install -g neovim @mermaid-js/mermaid-cli
  success "npm globals installed"
  NODE_MISSING=false
fi

# ─────────────────────────────────────────────────────────────────────────────
section "10 · Python Packages"
# ─────────────────────────────────────────────────────────────────────────────
info "Installing pynvim..."
pip install pynvim --break-system-packages
success "pynvim installed"

# ─────────────────────────────────────────────────────────────────────────────
section "11 · Back Up & Copy Dotfiles"
# ─────────────────────────────────────────────────────────────────────────────
# Get the absolute path of the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config.bak.$(date +%Y%m%d_%H%M%S)"

# Back up existing ~/.config if it exists and has contents
if [[ -d "$HOME/.config" ]] && [[ -n "$(ls -A "$HOME/.config" 2>/dev/null)" ]]; then
  info "Backing up existing ~/.config to $BACKUP_DIR ..."
  cp -r "$HOME/.config" "$BACKUP_DIR"
  success "Backup saved to $BACKUP_DIR"
else
  dim "No existing ~/.config to back up"
fi

info "Copying configs from $DOTFILES_DIR to ~/.config/..."
mkdir -p "$HOME/.config"

# Copy everything from current directory EXCEPT the script itself and the .git folder
# Using find to filter out current script and hidden git metadata
find "$DOTFILES_DIR" -maxdepth 1 ! -path "$DOTFILES_DIR" ! -name ".git" ! -name "$(basename "$0")" -exec cp -rv {} "$HOME/.config/" \;

success "Dotfiles copied to ~/.config"

# ─────────────────────────────────────────────────────────────────────────────
section "12 · Neovim Setup"
# ─────────────────────────────────────────────────────────────────────────────
# Since nvim config is now directly in ~/.config/nvim, we check if the setup script exists locally first
NVIM_SETUP_LOCAL="$DOTFILES_DIR/nvim/nvim-setup/install.sh"

if [[ -f "$NVIM_SETUP_LOCAL" ]]; then
  info "Running Neovim setup script from local path..."
  bash "$NVIM_SETUP_LOCAL"
else
  info "Running Neovim setup script from remote..."
  curl -fsSL https://raw.githubusercontent.com/Ramen96/dotfiles/main/nvim/nvim-setup/install.sh | bash
fi
success "Neovim setup complete"

# ── Done ──────────────────────────────────────────────────────────────────────
echo -e "
${GREEN}${BOLD}
  ╔═══════════════════════════════════════════════╗
  ║   All done! Your system is ready.             ║
  ╚═══════════════════════════════════════════════╝
${RESET}
${YELLOW}${BOLD}  Next steps:${RESET}
"
dim "› Log out and back in for the Zsh shell change to take effect"
dim "› Run 'p10k configure' on first Zsh launch to set up your prompt"
if [[ "${NODE_MISSING:-false}" == "true" ]]; then
  warn "Node.js was not found during install. Once installed, run:"
  dim "  npm install -g neovim @mermaid-js/mermaid-cli"
fi
if [[ -d "$BACKUP_DIR" ]]; then
  dim "› Your old ~/.config was backed up to: $BACKUP_DIR"
  dim "  You can delete it once you're happy: rm -rf $BACKUP_DIR"
fi
echo ""
