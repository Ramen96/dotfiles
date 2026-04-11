#!/usr/bin/env bash
# =============================================================================
#  LazyVim Dependency Installer — Ubuntu 24.04 / Raspberry Pi OS
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

ARCH="$(uname -m)"

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

apt_install() {
  local pkg="$1"
  if dpkg -s "$pkg" &>/dev/null 2>&1; then
    success "$pkg already installed — skipping."
    return
  fi
  if [[ "$DRY_RUN" == true ]]; then
    warn "[DRY RUN] Would run: sudo apt install -y $pkg"
    return
  fi
  info "Installing $pkg..."
  if sudo apt install -y "$pkg"; then
    dpkg -s "$pkg" &>/dev/null &&
      success "$pkg installed successfully." ||
      error "$pkg install reported success but package not found."
  else
    error "Failed to install $pkg via apt."
  fi
}

# ── Preflight ─────────────────────────────────────────────────────────────────
section "Preflight Checks"

command -v apt &>/dev/null || error "apt not found — this script requires Ubuntu 24.04 / Raspberry Pi OS."

if [[ "$DRY_RUN" == false ]]; then
  info "Updating package lists..."
  sudo apt update -y
  success "Package lists updated."
fi

# ── Core Tools ────────────────────────────────────────────────────────────────
section "Core Tools & Build Essentials"

for pkg in git ripgrep fd-find gcc build-essential cmake python3-pip; do
  apt_install "$pkg"
done

# fd-find is renamed to fdfind on Ubuntu — symlink it to fd
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
  if [[ "$DRY_RUN" == true ]]; then
    warn "[DRY RUN] Would symlink fdfind → /usr/local/bin/fd"
  else
    sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
    success "Symlinked fdfind → fd"
  fi
fi

# ── Lazygit ───────────────────────────────────────────────────────────────────
section "Lazygit"

if command -v lazygit &>/dev/null; then
  success "lazygit already installed: $(lazygit --version | head -1)"
else
  if [[ "$DRY_RUN" == true ]]; then
    warn "[DRY RUN] Would fetch and install latest lazygit binary for $ARCH"
  else
    info "Fetching latest lazygit release..."
    LG_VER=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" |
      grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')

    case "$ARCH" in
    aarch64 | arm64) LG_ARCH="arm64" ;;
    x86_64) LG_ARCH="x86_64" ;;
    armv7l) LG_ARCH="armv6" ;;
    *) error "Unsupported architecture for lazygit: $ARCH" ;;
    esac

    info "Downloading lazygit ${LG_VER} (${LG_ARCH})..."
    curl -Lo /tmp/lazygit.tar.gz \
      "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LG_VER}_Linux_${LG_ARCH}.tar.gz"
    tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
    sudo install /tmp/lazygit /usr/local/bin
    rm -f /tmp/lazygit.tar.gz /tmp/lazygit

    command -v lazygit &>/dev/null &&
      success "lazygit installed: $(lazygit --version | head -1)" ||
      error "lazygit binary not found after install."
  fi
fi

# ── Language Runtimes ─────────────────────────────────────────────────────────
section "Language Runtimes & Compilers"

apt_install clangd

# ── Go (from go.dev — apt version is too outdated) ────────────────────────────
section "Go"

install_go_from_source() {
  info "Fetching latest Go version..."
  GO_VER=$(curl -fsSL "https://go.dev/VERSION?m=text" | head -1)

  case "$ARCH" in
  aarch64 | arm64) GO_ARCH="arm64" ;;
  x86_64) GO_ARCH="amd64" ;;
  armv7l) GO_ARCH="armv6l" ;;
  *) error "Unsupported architecture for Go: $ARCH" ;;
  esac

  info "Downloading ${GO_VER} (${GO_ARCH})..."
  curl -Lo /tmp/go.tar.gz "https://go.dev/dl/${GO_VER}.linux-${GO_ARCH}.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf /tmp/go.tar.gz
  rm -f /tmp/go.tar.gz

  export PATH="$PATH:/usr/local/go/bin"

  if ! grep -q '/usr/local/go/bin' "$HOME/.profile" 2>/dev/null; then
    echo 'export PATH=$PATH:/usr/local/go/bin' >>"$HOME/.profile"
    info "Added Go to ~/.profile — run 'source ~/.profile' or open a new terminal."
  fi

  command -v go &>/dev/null &&
    success "Go installed: $(go version)" ||
    error "go binary not found after install."
}

if command -v go &>/dev/null; then
  CURRENT_GO="$(go version | awk '{print $3}')"
  LATEST_GO="$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -1)"
  if [[ "$CURRENT_GO" == "$LATEST_GO" ]]; then
    success "Go already up to date: $CURRENT_GO"
  else
    warn "Go $CURRENT_GO installed, latest is $LATEST_GO — updating..."
    if [[ "$DRY_RUN" == true ]]; then
      warn "[DRY RUN] Would update Go to $LATEST_GO"
    else
      install_go_from_source
    fi
  fi
else
  if [[ "$DRY_RUN" == true ]]; then
    warn "[DRY RUN] Would install latest Go from go.dev"
  else
    install_go_from_source
  fi
fi

# ── Rust ──────────────────────────────────────────────────────────────────────
section "Rust"

if command -v rustup &>/dev/null; then
  success "rustup already installed."
else
  if [[ "$DRY_RUN" == true ]]; then
    warn "[DRY RUN] Would install Rust via rustup"
  else
    info "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    source "$HOME/.cargo/env"
    command -v rustup &>/dev/null &&
      success "rustup installed successfully." ||
      error "rustup not found after install."
  fi
fi

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
  for pkg in docker.io docker-compose; do
    apt_install "$pkg"
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
  apt_install shellcheck

  # shfmt: not reliably in Ubuntu 24.04 apt — install via go install
  if command -v shfmt &>/dev/null; then
    success "shfmt already installed: $(shfmt --version)"
  elif command -v go &>/dev/null; then
    if [[ "$DRY_RUN" == true ]]; then
      warn "[DRY RUN] Would install shfmt via go install"
    else
      info "Installing shfmt via go install..."
      go install mvdan.cc/sh/v3/cmd/shfmt@latest
      export PATH="$PATH:$(go env GOPATH)/bin"
      command -v shfmt &>/dev/null &&
        success "shfmt installed: $(shfmt --version)" ||
        warn "shfmt not found in PATH — ensure $(go env GOPATH)/bin is in your PATH."
    fi
  else
    warn "go not available yet — shfmt will be skipped. Re-run after Go is set up."
  fi

  # stylua: apt version is outdated — install via cargo
  if command -v stylua &>/dev/null; then
    success "stylua already installed: $(stylua --version)"
  elif command -v cargo &>/dev/null; then
    if [[ "$DRY_RUN" == true ]]; then
      warn "[DRY RUN] Would install stylua via cargo"
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

  if [[ "$DRY_RUN" == true ]]; then
    warn "[DRY RUN] Would install pyright ruff flake8 via pip"
  else
    info "Installing pyright, ruff, flake8 via pip..."
    pip3 install --break-system-packages pyright ruff flake8

    for tool in pyright ruff flake8; do
      command -v "$tool" &>/dev/null &&
        success "$tool installed successfully." ||
        warn "$tool not found in PATH — it may be in ~/.local/bin. Add it to your PATH."
    done
  fi
fi

# ── Done ──────────────────────────────────────────────────────────────────────
section "Done"

echo -e "  ${GREEN}${BOLD}Ubuntu 24.04 install complete!${RESET}"
echo -e "  Post-install steps will run next via post_install.sh\n"
