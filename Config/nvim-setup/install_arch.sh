#!/usr/bin/env bash
# =============================================================================
#  LazyVim Dependency Installer — Arch Linux (x86_64)
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

pacman_install() {
  local pkg="$1"
  if pacman -Qi "$pkg" &>/dev/null; then
    success "$pkg already installed — skipping."
    return
  fi
  if [[ "$DRY_RUN" == true ]]; then
    warn "[DRY RUN] Would run: sudo pacman -S --needed --noconfirm $pkg"
    return
  fi
  info "Installing $pkg..."
  if sudo pacman -S --needed --noconfirm "$pkg"; then
    pacman -Qi "$pkg" &>/dev/null &&
      success "$pkg installed successfully." ||
      error "$pkg install reported success but package not found."
  else
    error "Failed to install $pkg via pacman."
  fi
}

aur_install() {
  local pkg="$1"
  if pacman -Qi "$pkg" &>/dev/null; then
    success "$pkg already installed — skipping."
    return
  fi
  if [[ "$DRY_RUN" == true ]]; then
    warn "[DRY RUN] Would run: $AUR_HELPER -S --needed --noconfirm $pkg"
    return
  fi
  info "Installing $pkg from AUR via $AUR_HELPER..."
  if $AUR_HELPER -S --needed --noconfirm "$pkg"; then
    pacman -Qi "$pkg" &>/dev/null &&
      success "$pkg installed successfully." ||
      error "$pkg install reported success but package not found."
  else
    error "Failed to install $pkg from AUR."
  fi
}

# ── Preflight ─────────────────────────────────────────────────────────────────
section "Preflight Checks"

command -v pacman &>/dev/null || error "pacman not found — this script requires Arch Linux."

if [[ "$DRY_RUN" == false ]]; then
  info "Syncing package databases..."
  sudo pacman -Sy --noconfirm
  success "Package databases synced."
fi

# ── AUR Helper ────────────────────────────────────────────────────────────────
section "AUR Helper"

# Detect existing AUR helper, or install yay
AUR_HELPER=""
for helper in yay paru; do
  if command -v "$helper" &>/dev/null; then
    AUR_HELPER="$helper"
    success "Found AUR helper: $AUR_HELPER"
    break
  fi
done

if [[ -z "$AUR_HELPER" ]]; then
  if [[ "$DRY_RUN" == true ]]; then
    warn "[DRY RUN] No AUR helper found — would install yay."
    AUR_HELPER="yay"
  else
    info "No AUR helper found — installing yay..."
    pacman_install git
    pacman_install base-devel
    # Fix: use a plain variable (not local) since this is top-level scope
    tmp_dir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay"
    cd "$tmp_dir/yay"
    makepkg -si --noconfirm
    cd -
    rm -rf "$tmp_dir"
    command -v yay &>/dev/null &&
      success "yay installed successfully." ||
      error "yay installation failed."
    AUR_HELPER="yay"
  fi
fi

# ── Core Tools ────────────────────────────────────────────────────────────────
section "Core Tools & Build Essentials"

for pkg in git lazygit fd ripgrep cmake base-devel; do
  pacman_install "$pkg"
done

# ── Language Runtimes ─────────────────────────────────────────────────────────
section "Language Runtimes & Compilers"

for pkg in clang lldb rustup go; do
  pacman_install "$pkg"
done

# ── Node.js ───────────────────────────────────────────────────────────────────
section "Node.js"

if command -v node &>/dev/null; then
  success "Node.js already installed: $(node --version)"
else
  if [[ "$DRY_RUN" == true ]]; then
    warn "[DRY RUN] Would install nvm and Node.js LTS"
  else
    info "Installing nvm..."
    NVM_DIR="$HOME/.nvm"
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
    # Source nvm immediately so we can use it in this session
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
    pacman_install "$pkg"
  done

  if [[ "$DRY_RUN" == false ]]; then
    info "Enabling Docker service..."
    sudo systemctl enable --now docker
    success "Docker service enabled."

    info "Adding $USER to docker group..."
    sudo usermod -aG docker "$USER"
    success "Added to docker group. Log out and back in to apply."
  else
    warn "[DRY RUN] Would enable Docker service and add $USER to docker group."
  fi
fi

# ── LSPs & Formatters ─────────────────────────────────────────────────────────
section "LSPs & Formatters"

if [[ "$SKIP_LSP" == true ]]; then
  warn "Skipping LSPs & formatters (--skip-lsp)."
else
  # These are in official repos
  for pkg in shellcheck shfmt; do
    pacman_install "$pkg"
  done

  # stylua, pyright, and ruff via AUR
  for pkg in stylua pyright ruff; do
    aur_install "$pkg"
  done
fi

# ── Done ──────────────────────────────────────────────────────────────────────
section "Done"

echo -e "  ${GREEN}${BOLD}Arch Linux install complete!${RESET}"
echo -e "  Post-install steps will run next via post_install.sh\n"
