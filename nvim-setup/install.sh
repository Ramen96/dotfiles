#!/usr/bin/env bash
# =============================================================================
#  LazyVim Dependency Installer — Master Script
#  Detects OS/arch and delegates to the appropriate install script.
#
#  Curl usage (no flags):
#    curl -fsSL https://raw.githubusercontent.com/Ramen96/dotfiles/main/Config/nvim-setup/install.sh | bash
#
#  Local usage (flags supported):
#    bash install.sh [--dry-run] [--skip-docker] [--skip-lsp] [--skip-post]
# =============================================================================

set -euo pipefail

BASE_URL="https://raw.githubusercontent.com/Ramen96/dotfiles/main/Config/nvim-setup"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Flag parsing ──────────────────────────────────────────────────────────────
DRY_RUN=false
SKIP_DOCKER=false
SKIP_LSP=false
SKIP_POST=false

for arg in "$@"; do
  case "$arg" in
  --dry-run) DRY_RUN=true ;;
  --skip-docker) SKIP_DOCKER=true ;;
  --skip-lsp) SKIP_LSP=true ;;
  --skip-post) SKIP_POST=true ;;
  --help)
    echo "Usage: $0 [--dry-run] [--skip-docker] [--skip-lsp] [--skip-post]"
    exit 0
    ;;
  *)
    echo "Unknown flag: $arg"
    exit 1
    ;;
  esac
done

export DRY_RUN SKIP_DOCKER SKIP_LSP SKIP_POST

# ── Helpers ───────────────────────────────────────────────────────────────────
banner() {
  echo -e "${CYAN}${BOLD}"
  echo "  ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗"
  echo "  ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║"
  echo "  ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║"
  echo "  ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║"
  echo "  ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║"
  echo "  ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝"
  echo -e "${RESET}"
  echo -e "  ${BOLD}Dependency Installer${RESET} — Detecting your environment...\n"
  if [[ "$DRY_RUN" == true ]]; then
    echo -e "  ${YELLOW}[DRY RUN]${RESET} No changes will be made.\n"
  fi
}

info() { echo -e "  ${CYAN}[INFO]${RESET}  $*"; }
success() { echo -e "  ${GREEN}[OK]${RESET}    $*"; }
warn() { echo -e "  ${YELLOW}[WARN]${RESET}  $*"; }
error() {
  echo -e "  ${RED}[ERROR]${RESET} $*"
  exit 1
}

# ── OS Detection ──────────────────────────────────────────────────────────────
detect_os() {
  case "$(uname -s)" in
  Darwin)
    if [[ "$(uname -m)" == "arm64" ]]; then
      echo "macos"
    else
      warn "Detected macOS on non-Apple-Silicon. The macOS script targets Apple Silicon / Homebrew."
      echo "macos"
    fi
    ;;
  Linux)
    if [[ -f /etc/os-release ]]; then
      source /etc/os-release
      case "$ID" in
      arch) echo "arch" ;;
      ubuntu | debian) echo "ubuntu" ;;
      raspbian) echo "ubuntu" ;;
      *)
        warn "Unrecognised Linux distro: $ID. Falling back to Ubuntu script."
        echo "ubuntu"
        ;;
      esac
    else
      error "Cannot read /etc/os-release. Unable to detect Linux distro."
    fi
    ;;
  *)
    error "Unsupported OS: $(uname -s)"
    ;;
  esac
}

# ── Runners ───────────────────────────────────────────────────────────────────
build_flags() {
  local flags=()
  [[ "$SKIP_DOCKER" == true ]] && flags+=("--skip-docker")
  [[ "$SKIP_LSP" == true ]] && flags+=("--skip-lsp")
  echo "${flags[@]:-}"
}

run_installer() {
  local target="$1"
  local flags=()
  [[ "$SKIP_DOCKER" == true ]] && flags+=("--skip-docker")
  [[ "$SKIP_LSP" == true ]] && flags+=("--skip-lsp")

  if [[ "$DRY_RUN" == true ]]; then
    info "[DRY RUN] Would fetch and run: install_${target}.sh${flags:+" ${flags[*]}"}"
    return
  fi

  info "Fetching install_${target}.sh from GitHub...\n"
  curl -fsSL "${BASE_URL}/install_${target}.sh" | bash -s -- "${flags[@]}"
}

run_post_install() {
  if [[ "$SKIP_POST" == true ]]; then
    warn "Skipping post-install script (--skip-post)."
    return
  fi

  if [[ "$DRY_RUN" == true ]]; then
    info "[DRY RUN] Would fetch and run: post_install.sh"
    return
  fi

  info "Fetching post_install.sh from GitHub...\n"
  curl -fsSL "${BASE_URL}/post_install.sh" | bash
}

# ── Main ──────────────────────────────────────────────────────────────────────
banner

OS="$(detect_os)"

case "$OS" in
macos)
  success "Detected: ${BOLD}macOS (Apple Silicon)${RESET}"
  run_installer "macos"
  ;;
arch)
  success "Detected: ${BOLD}Arch Linux${RESET}"
  run_installer "arch"
  ;;
ubuntu)
  success "Detected: ${BOLD}Ubuntu / Debian / Raspberry Pi OS ($(uname -m))${RESET}"
  run_installer "ubuntu"
  ;;
esac

run_post_install
