#!/usr/bin/env bash
# =============================================================================
#  LazyVim Post-Install Script
#  Runs after the OS-specific installer. Handles steps that are the same
#  across all platforms: Rust toolchain init, tree-sitter, and a final
#  health check that prints a summary of everything installed.
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
error() { echo -e "  ${RED}✘${RESET}  $*"; }
section() { echo -e "\n  ${BOLD}── $* ──${RESET}\n"; }

# ── Rust Toolchain ────────────────────────────────────────────────────────────
section "Rust Toolchain"

# Source cargo env in case this is a fresh rustup install
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

if command -v rustup &>/dev/null; then
  info "Setting Rust stable as default toolchain..."
  rustup default stable
  success "Rust stable toolchain active: $(rustc --version)"
else
  warn "rustup not found — skipping. If Rust was just installed, open a new terminal and run:"
  warn "  rustup default stable"
fi

# ── Tree-sitter CLI ───────────────────────────────────────────────────────────
section "Tree-sitter CLI"

if command -v tree-sitter &>/dev/null; then
  success "tree-sitter-cli already installed: $(tree-sitter --version)"
else
  if command -v npm &>/dev/null; then
    info "Installing tree-sitter-cli via npm..."
    npm install -g tree-sitter-cli
    command -v tree-sitter &>/dev/null &&
      success "tree-sitter-cli installed: $(tree-sitter --version)" ||
      warn "tree-sitter not found in PATH after install — check your npm global bin path."
  else
    warn "npm not available — install Node.js first from https://nodejs.org/"
    warn "Then run: npm install -g tree-sitter-cli"
  fi
fi

# ── Health Check ──────────────────────────────────────────────────────────────
section "Health Check"

check() {
  local name="$1"
  local cmd="$2"
  local version_flag="${3:---version}"

  if command -v "$cmd" &>/dev/null; then
    local ver
    ver=$($cmd $version_flag 2>&1 | head -1) || ver="(version unknown)"
    printf "  ${GREEN}✔${RESET}  %-20s %s\n" "$name" "$ver"
  else
    printf "  ${YELLOW}⚠${RESET}  %-20s %s\n" "$name" "NOT FOUND"
  fi
}

echo ""
check "git" git
check "lazygit" lazygit "--version"
check "fd" fd "--version"
check "ripgrep" rg "--version"
check "cmake" cmake "--version"
check "gcc / clang" gcc "--version"
check "rustc" rustc "--version"
check "cargo" cargo "--version"
check "rustup" rustup "--version"
check "go" go "version"
check "node" node "--version"
check "npm" npm "--version"
check "tree-sitter" tree-sitter "--version"
check "docker" docker "--version"
check "docker-compose" docker-compose "--version"
check "pyright" pyright "--version"
check "ruff" ruff "--version"
check "stylua" stylua "--version"
check "shellcheck" shellcheck "--version"
check "shfmt" shfmt "--version"
echo ""

# ── Final Notes ───────────────────────────────────────────────────────────────
section "Next Steps"

echo -e "  ${YELLOW}1.${RESET} If Node.js shows NOT FOUND — install from https://nodejs.org/"
echo -e "     then run: ${CYAN}npm install -g tree-sitter-cli${RESET}"
echo ""
echo -e "  ${YELLOW}2.${RESET} If Docker shows NOT FOUND or you see permission errors:"
echo -e "     ${CYAN}sudo usermod -aG docker \$USER${RESET}  then log out and back in."
echo ""
echo -e "  ${YELLOW}3.${RESET} If Go or Rust aren't in PATH, open a new terminal or run:"
echo -e "     ${CYAN}source ~/.profile${RESET}  (Go)   |   ${CYAN}source ~/.cargo/env${RESET}  (Rust)"
echo ""
echo -e "  ${GREEN}${BOLD}All done! Open Neovim and run :Lazy to finish plugin installation.${RESET}\n"
