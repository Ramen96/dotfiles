#!/usr/bin/env bash
# =============================================================================
#  LazyVim Dependency Installer — Arch Linux (x86_64)
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

# ── Preflight ─────────────────────────────────────────────────────────────────
section "Preflight Checks"

if ! command -v pacman &>/dev/null; then
  error "pacman not found. This script requires Arch Linux."
fi

info "Syncing package databases..."
sudo pacman -Sy --noconfirm
success "Package databases synced."

# ── Core Tools ────────────────────────────────────────────────────────────────
section "Core Tools & Build Essentials"

CORE_PKGS=(git lazygit fd ripgrep cmake base-devel)
info "Installing core packages: ${CORE_PKGS[*]}"
sudo pacman -S --needed --noconfirm "${CORE_PKGS[@]}"
success "Core tools installed."

# ── Language Runtimes ─────────────────────────────────────────────────────────
section "Language Runtimes & Compilers"

LANG_PKGS=(clang lldb rustup go)
info "Installing language runtimes: ${LANG_PKGS[*]}"
sudo pacman -S --needed --noconfirm "${LANG_PKGS[@]}"
success "Language runtimes installed."

# ── Node.js ───────────────────────────────────────────────────────────────────
section "Node.js"

if command -v node &>/dev/null; then
  success "Node.js already installed: $(node --version)"
else
  warn "Node.js is NOT installed."
  warn "Please install it from: https://nodejs.org/"
  warn "Your Tailwind and Angular extras depend on Node & NPM being in PATH."
fi

# ── Docker ────────────────────────────────────────────────────────────────────
section "Docker"

DOCKER_PKGS=(docker docker-compose)
info "Installing Docker packages: ${DOCKER_PKGS[*]}"
sudo pacman -S --needed --noconfirm "${DOCKER_PKGS[@]}"
success "Docker installed."

# Enable and start Docker service
info "Enabling Docker service..."
sudo systemctl enable --now docker
success "Docker service enabled and started."

# Add current user to docker group so Neovim can access the socket without sudo
info "Adding ${USER} to the docker group..."
sudo usermod -aG docker "$USER"
success "User added to docker group. (Log out and back in to apply.)"

# ── LSPs & Formatters ─────────────────────────────────────────────────────────
section "LSPs & Formatters"

LSP_PKGS=(pyright ruff stylua shellcheck shfmt)
info "Installing LSPs and formatters: ${LSP_PKGS[*]}"
sudo pacman -S --needed --noconfirm "${LSP_PKGS[@]}"
success "LSPs and formatters installed."

# ── Post-Install ──────────────────────────────────────────────────────────────
section "Post-Install Configuration"

# Rust: initialize stable toolchain
if command -v rustup &>/dev/null; then
  info "Initialising Rust stable toolchain..."
  rustup default stable
  success "Rust stable toolchain set."
else
  warn "rustup not found — skipping Rust toolchain init."
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

echo -e "  ${GREEN}${BOLD}Arch Linux setup complete!${RESET}\n"
echo -e "  Remaining manual steps:"
echo -e "  ${YELLOW}1.${RESET} Install Node.js from https://nodejs.org/ (if not already done)"
echo -e "  ${YELLOW}2.${RESET} After installing Node, run: npm install -g tree-sitter-cli"
echo -e "  ${YELLOW}3.${RESET} Log out and back in (or run 'newgrp docker') for Docker group to take effect."
echo -e "  ${YELLOW}4.${RESET} Open a new terminal so all PATH changes take effect."
echo
