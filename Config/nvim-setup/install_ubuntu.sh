#!/usr/bin/env bash
# =============================================================================
#  LazyVim Dependency Installer — Ubuntu / Debian / Raspberry Pi OS (aarch64)
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info() { echo -e "  ${CYAN}›${RESET}  $*"; }
success() { echo -e "  ${GREEN}✔${RESET}  $*"; }
warn() { echo -e "  ${YELLOW}⚠${RESET}  $*"; }
error() {
  echo -e "  ${RED}✘${RESET}  $*"
  exit 1
}
section() { echo -e "\n  ${BOLD}── $* ──${RESET}\n"; }

ARCH="$(uname -m)"

# ── Preflight ─────────────────────────────────────────────────────────────────
section "Preflight Checks"

if ! command -v apt &>/dev/null; then
  error "apt not found. This script requires Ubuntu / Debian / Raspberry Pi OS."
fi

info "Updating package lists..."
sudo apt update -y
success "Package lists updated."

# ── Core Tools ────────────────────────────────────────────────────────────────
section "Core Tools & Build Essentials"

CORE_PKGS=(git ripgrep fd-find gcc build-essential cmake python3-pip)
info "Installing core packages: ${CORE_PKGS[*]}"
sudo apt install -y "${CORE_PKGS[@]}"
success "Core tools installed."

# fd-find installs as 'fdfind' on Ubuntu; symlink to 'fd'
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
  info "Symlinking fdfind → fd..."
  sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
  success "fd symlink created."
fi

# ── Lazygit (manual install — no ARM64 package in apt) ───────────────────────
section "Lazygit"

if command -v lazygit &>/dev/null; then
  success "lazygit already installed: $(lazygit --version | head -1)"
else
  info "Fetching latest lazygit release..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" |
    grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')

  # Pick the correct archive for this architecture
  case "$ARCH" in
  aarch64 | arm64) LAZYGIT_ARCH="arm64" ;;
  x86_64) LAZYGIT_ARCH="x86_64" ;;
  armv7l) LAZYGIT_ARCH="armv6" ;;
  *) error "Unsupported architecture for lazygit: $ARCH" ;;
  esac

  LAZYGIT_URL="https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz"
  info "Downloading lazygit ${LAZYGIT_VERSION} (${LAZYGIT_ARCH})..."
  curl -Lo /tmp/lazygit.tar.gz "$LAZYGIT_URL"
  tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
  sudo install /tmp/lazygit /usr/local/bin
  rm -f /tmp/lazygit.tar.gz /tmp/lazygit
  success "lazygit installed: $(lazygit --version | head -1)"
fi

# ── Language Runtimes ─────────────────────────────────────────────────────────
section "Language Runtimes & Compilers"

# Clang / LLDB
info "Installing clangd & golang-go..."
sudo apt install -y clangd golang-go
success "clangd and Go installed."

# Docker
info "Installing Docker..."
sudo apt install -y docker.io docker-compose
success "Docker installed."

# Enable and start Docker service
info "Enabling Docker service..."
sudo systemctl enable --now docker
success "Docker service enabled and started."

# Add current user to docker group so Neovim can access the socket without sudo
info "Adding ${USER} to the docker group..."
sudo usermod -aG docker "$USER"
success "User added to docker group. (Log out and back in to apply.)"

# Rust via rustup
if command -v rustup &>/dev/null; then
  success "rustup already installed."
else
  info "Installing Rust via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  source "$HOME/.cargo/env"
  success "Rust installed via rustup."
fi

# ── Node.js ───────────────────────────────────────────────────────────────────
section "Node.js"

if command -v node &>/dev/null; then
  success "Node.js already installed: $(node --version)"
else
  warn "Node.js is NOT installed."
  warn "Please install it from: https://nodejs.org/"
  warn "Your Tailwind and Angular extras depend on Node & NPM being in PATH."
fi

# ── LSPs & Formatters ─────────────────────────────────────────────────────────
section "LSPs & Formatters"

APT_LSP_PKGS=(stylua shellcheck shfmt)
info "Installing LSPs via apt: ${APT_LSP_PKGS[*]}"
sudo apt install -y "${APT_LSP_PKGS[@]}"
success "apt LSP packages installed."

info "Installing pyright and ruff via pip..."
pip install --break-system-packages pyright ruff flake8 2>/dev/null ||
  pip3 install pyright ruff flake8
success "pyright, ruff, and flake8 installed via pip."

# ── Post-Install ──────────────────────────────────────────────────────────────
section "Post-Install Configuration"

# Rust: initialize stable toolchain
if command -v rustup &>/dev/null; then
  info "Initialising Rust stable toolchain..."
  rustup default stable
  success "Rust stable toolchain set."
else
  warn "rustup not in PATH yet — run 'source ~/.cargo/env' then 'rustup default stable'."
fi

# Tree-sitter CLI
if command -v npm &>/dev/null; then
  info "Installing tree-sitter-cli via npm..."
  npm install -g tree-sitter-cli
  success "tree-sitter-cli installed."
else
  warn "npm not available — install Node.js first, then run:"
  warn "  npm install -g tree-sitter-cli"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
section "Done"

echo -e "  ${GREEN}${BOLD}Ubuntu / Raspberry Pi OS setup complete!${RESET}\n"
echo -e "  Remaining manual steps:"
echo -e "  ${YELLOW}1.${RESET} Install Node.js from https://nodejs.org/ (if not already done)"
echo -e "  ${YELLOW}2.${RESET} After installing Node, run: npm install -g tree-sitter-cli"
echo -e "  ${YELLOW}3.${RESET} Log out and back in (or run 'newgrp docker') for Docker group to take effect."
echo -e "  ${YELLOW}4.${RESET} If Rust isn't in PATH, run: source ~/.cargo/env"
echo -e "  ${YELLOW}5.${RESET} Open a new terminal so all PATH changes take effect."
echo
