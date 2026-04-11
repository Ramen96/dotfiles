#!/usr/bin/env bash
# =============================================================================
#  LazyVim Dependency Installer — macOS (Apple Silicon / M-series)
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

if ! command -v brew &>/dev/null; then
  info "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for Apple Silicon
  eval "$(/opt/homebrew/bin/brew shellenv)"
  success "Homebrew installed."
else
  success "Homebrew already installed."
  brew update
fi

# ── Core Tools ────────────────────────────────────────────────────────────────
section "Core Tools & Build Essentials"

CORE_PKGS=(git lazygit fd ripgrep cmake gcc)
for pkg in "${CORE_PKGS[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    success "$pkg already installed — skipping."
  else
    info "Installing $pkg..."
    brew install "$pkg"
    success "$pkg installed."
  fi
done

# ── Language Runtimes ─────────────────────────────────────────────────────────
section "Language Runtimes & Compilers"

LANG_PKGS=(llvm rustup golang)
for pkg in "${LANG_PKGS[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    success "$pkg already installed — skipping."
  else
    info "Installing $pkg..."
    brew install "$pkg"
    success "$pkg installed."
  fi
done

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
for pkg in "${DOCKER_PKGS[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    success "$pkg already installed — skipping."
  else
    info "Installing $pkg..."
    brew install "$pkg"
    success "$pkg installed."
  fi
done

# ── LSPs & Formatters ─────────────────────────────────────────────────────────
section "LSPs & Formatters"

LSP_PKGS=(pyright ruff stylua shellcheck shfmt)
for pkg in "${LSP_PKGS[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    success "$pkg already installed — skipping."
  else
    info "Installing $pkg..."
    brew install "$pkg"
    success "$pkg installed."
  fi
done

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

echo -e "  ${GREEN}${BOLD}macOS setup complete!${RESET}\n"
echo -e "  Remaining manual steps:"
echo -e "  ${YELLOW}1.${RESET} Install Node.js from https://nodejs.org/ (if not already done)"
echo -e "  ${YELLOW}2.${RESET} After installing Node, run: npm install -g tree-sitter-cli"
echo -e "  ${YELLOW}3.${RESET} Open a new terminal so all PATH changes take effect."
echo
