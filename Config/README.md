```markdown
# 💤 LazyVim

## Auto-Install Dependencies
---
Run this one-liner to automatically detect your OS and install all dependencies:

```bash
curl -fsSL https://raw.githubusercontent.com/Ramen96/dotfiles/main/Config/nvim-setup/install.sh | bash
```

> Supports macOS (Apple Silicon), Arch Linux, Ubuntu, Debian, and Raspberry Pi OS.
> Node.js must still be installed manually from [nodejs.org](https://nodejs.org/) — see Post-Install Requirements below.

---
## Manual Installation
---
### macOS (Apple Silicon)
```bash
# Core Tools & Build Essentials
brew install git lazygit fd ripgrep cmake gcc
# Language Runtimes & Compilers
brew install llvm rustup golang
# Install Node.js via: https://nodejs.org/
# Docker (Desktop or Colima)
brew install docker docker-compose
# LSPs & Formatters
brew install pyright ruff stylua shellcheck shfmt
```
---
### Arch Linux (x86_64)
```bash
# Core Tools & Build Essentials
sudo pacman -S git lazygit fd ripgrep cmake base-devel
# Language Runtimes & Compilers
sudo pacman -S clang lldb rustup go
# Install Node.js via: https://nodejs.org/
# Docker
sudo pacman -S docker docker-compose
# LSPs & Formatters
sudo pacman -S pyright ruff stylua shellcheck shfmt
```
---
### Ubuntu / Raspberry Pi OS (aarch64)
```bash
# Core Tools & Build Essentials
sudo apt update
sudo apt install -y git ripgrep fd-find gcc build-essential cmake python3-pip
# Lazygit (Manual ARM64 install for Ubuntu 24.04)
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_arm64.tar.gz"
tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
sudo install /tmp/lazygit /usr/local/bin
# Language Runtimes & Compilers
sudo apt install -y clangd golang-go docker.io docker-compose
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# Install Node.js via: https://nodejs.org/
# LSPs & Formatters
sudo apt install -y stylua shellcheck shfmt
pip install pyright ruff flake8
```
---
### Post-Install Requirements
1. **Rust:** Run `rustup default stable` after installing to initialize the toolchain.
2. **Docker:** On Linux, run `sudo usermod -aG docker $USER` so Neovim can access the Docker socket without sudo.
3. **Node:** Ensure Node.js and NPM are installed from the [official website](https://nodejs.org/). Your Tailwind and Angular extras depend on these being in your PATH.
4. **Tree-sitter:** After installing Node/NPM, run `npm install -g tree-sitter-cli` to allow Neovim to compile language parsers.
```
