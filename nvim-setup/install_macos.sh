#!/usr/bin/env bash
# =============================================================================
#  LazyVim Dependency Installer — macOS (Apple Silicon)
#
#  Flags:
#    --dry-run        Print what would be done without executing
#    --skip-docker    Skip Docker installation
#    --skip-lsp       Skip LSP & formatter installation
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Flag parsing ──────────────────────────────────────────────────────────────
DRY_RUN="${DRY_RUN:-false}"
SKIP_DOCKER="${SKIP_DOCKER:-false}"
SKIP_LSP="${SKIP_LSP:-false}"

for arg in "$@"; do
  case "$arg" in
  --dry-run) DRY_RUN=true ;;
  --skip-docker) SKIP_DOCKER=true ;;
  --skip-lsp) SKIP_LSP=true ;;
  esac
done

# ── Helpers ───────────────────────────────────────────────────────────────────
info() { echo -e "  ${CYAN}›${RESET}  $*"; }
success() { echo -e "  ${GREEN}✔${RESET}  $*"; }
warn() { echo -e "  ${YELLOW}⚠${RESET}  $*"; }
error() {
  echo -e "  ${RED}✘${RESET}  $*"
  exit 1
}
section() { echo -e "\n  ${BOLD}── $* ──${RESET}\n"; }

dry_run_notice() {
  [[ "$DRY_RUN" == true ]] && warn "[DRY RUN] Would run: $*"
}

# Installs a brew package and verifies it's available afterwards
brew_install() {
  local pkg="$1"
  if brew list "$pkg" &>/dev/null; then
    success "$pkg already installed — skipping."
    return
  fi
  if [[ "$DRY_RUN" == true ]]; then
    dry_run_notice "brew install $pkg"
    return
  fi
  info "Installing $pkg..."
  if brew install "$pkg"; then
    if brew list "$pkg" &>/dev/null; then
      success "$pkg installed successfully."
    else
      error "$pkg install reported success but package not found — check brew output above."
    fi
  else
    error "Failed to install $pkg via brew."
  fi
}

# ── Preflight ─────────────────────────────────────────────────────────────────
section "Preflight Checks"

if ! command -v brew &>/dev/null; then
  if [[ "$DRY_RUN" == true ]]; then
    dry_run_notice "Install Homebrew"
  else
    info "Homebrew not found — installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    success "Homebrew installed."
  fi
else
  success "Homebrew already installed."
  [[ "$DRY_RUN" == false ]] && brew update
fi

# ── Core Tools ────────────────────────────────────────────────────────────────
section "Core Tools & Build Essentials"

for pkg in git lazygit fd ripgrep cmake gcc; do
  brew_install "$pkg"
done

# ── Language Runtimes ─────────────────────────────────────────────────────────
section "Language Runtimes & Compilers"

for pkg in llvm rustup golang; do
  brew_install "$pkg"
done

# ── Node.js ───────────────────────────────────────────────────────────────────
section "Node.js"

if command -v node &>/dev/null; then
  success "Node.js already installed: $(node --version)"
else
  if [[ "$DRY_RUN" == true ]]; then
    dry_run_notice "Install nvm and Node.js LTS"
  else
    info "Installing nvm..."
    NVM_DIR="$HOME/.nvm"
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    info "Installing Node.js LTS via nvm..."
    nvm install --lts
    nvm use --lts
    command -v node &>/dev/null &&
      success "Node.js installed: $(node --version)" ||
      warn "node not found in PATH — open a new terminal and run: nvm install --lts"
  fi
fi

# ── Docker ────────────────────────────────────────────────────────────────────
section "Docker"

if [[ "$SKIP_DOCKER" == true ]]; then
  warn "Skipping Docker (--skip-docker)."
else
  for pkg in docker docker-compose; do
    brew_install "$pkg"
  done
fi

# ── LSPs & Formatters ─────────────────────────────────────────────────────────
section "LSPs & Formatters"

if [[ "$SKIP_LSP" == true ]]; then
  warn "Skipping LSPs & formatters (--skip-lsp)."
else
  for pkg in pyright ruff shellcheck shfmt; do
    brew_install "$pkg"
  done

  # stylua: brew formula is often outdated — install latest via cargo
  if command -v stylua &>/dev/null; then
    success "stylua already installed: $(stylua --version)"
  elif command -v cargo &>/dev/null; then
    if [[ "$DRY_RUN" == true ]]; then
      dry_run_notice "cargo install stylua"
    else
      info "Installing stylua via cargo..."
      cargo install stylua
      command -v stylua &>/dev/null &&
        success "stylua installed: $(stylua --version)" ||
        warn "stylua not found in PATH — ensure ~/.cargo/bin is in your PATH."
    fi
  else
    warn "cargo not available yet — stylua will be skipped. Re-run after Rust is set up."
  fi
fi

# ── Done ──────────────────────────────────────────────────────────────────────
section "Done"

echo -e "  ${GREEN}${BOLD}macOS install complete!${RESET}"
echo -e "  Post-install steps will run next via post_install.sh\n"
