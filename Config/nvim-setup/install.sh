#!/usr/bin/env bash
# =============================================================================
#  LazyVim Dependency Installer — Master Script
#  Detects OS/arch and delegates to the appropriate install script.
# =============================================================================
set -euo pipefail

BASE_URL="https://raw.githubusercontent.com/Ramen96/dotfiles/main/Config/nvim-setup"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

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
}

info() { echo -e "  ${CYAN}[INFO]${RESET}  $*"; }
success() { echo -e "  ${GREEN}[OK]${RESET}    $*"; }
warn() { echo -e "  ${YELLOW}[WARN]${RESET}  $*"; }
error() {
  echo -e "  ${RED}[ERROR]${RESET} $*"
  exit 1
}

detect_os() {
  local os arch
  case "$(uname -s)" in
  Darwin)
    arch="$(uname -m)"
    if [[ "$arch" == "arm64" ]]; then
      echo "macos"
    else
      warn "Detected macOS on non-Apple-Silicon. The macOS script targets Apple Silicon / Homebrew."
      echo "macos"
    fi
    ;;
  Linux)
    arch="$(uname -m)"
    if [[ -f /etc/os-release ]]; then
      source /etc/os-release
      case "$ID" in
      arch) echo "arch" ;;
      ubuntu | debian) echo "ubuntu" ;;
      raspbian) echo "ubuntu" ;;
      *)
        warn "Unrecognised Linux distro: $ID. Attempting Ubuntu script as fallback."
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

run_installer() {
  local target="$1"
  info "Fetching install_${target}.sh from GitHub...\n"
  curl -fsSL "${BASE_URL}/install_${target}.sh" | bash
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
  ARCH="$(uname -m)"
  success "Detected: ${BOLD}Ubuntu / Debian / Raspberry Pi OS (${ARCH})${RESET}"
  run_installer "ubuntu"
  ;;
esac
