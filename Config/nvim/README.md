# 💤 LazyVim

## Auto-Install Dependencies

---

Run this one-liner to automatically detect your OS and install all dependencies:

```bash
curl -fsSL https://raw.githubusercontent.com/Ramen96/dotfiles/main/Config/nvim-setup/install.sh | bash
```

> Supports macOS (Apple Silicon), Arch Linux, Ubuntu, Debian, and Raspberry Pi OS.

Optional flags:

| Flag | Description |
|------|-------------|
| `--dry-run` | Print what would be done without making any changes |
| `--skip-docker` | Skip Docker installation |
| `--skip-lsp` | Skip LSP & formatter installation |
| `--skip-post` | Skip the post-install script |

> **Note (fresh Ubuntu machines):** `stylua` and `shfmt` are installed via `cargo` and `go install` respectively rather than apt, since the apt versions are outdated. On a completely fresh machine, Rust and Go are installed earlier in the same script run, but may not be in your current shell's PATH yet. If either tool shows as missing after the install completes, simply re-run the script — everything else will be skipped as already installed and only the missing tools will be picked up.

---

## Manual Installation

---

### macOS (Apple Silicon)

```bash
# Core Tools & Build Essentials
brew install git lazygit fd ripgrep cmake gcc

# Language Runtimes & Compilers
brew install llvm rustup golang

# Node.js via nvm (recommended)
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
nvm install --lts

# Docker (Desktop or Colima)
brew install docker docker-compose

# LSPs & Formatters
brew install pyright ruff shellcheck shfmt

# stylua via cargo (brew formula is often outdated)
cargo install stylua
```

---

### Arch Linux (x86_64)

```bash
# Core Tools & Build Essentials
sudo pacman -S git lazygit fd ripgrep cmake base-devel

# Language Runtimes & Compilers
sudo pacman -S clang lldb rustup go

# Node.js via nvm (recommended)
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
nvm install --lts

# Docker
sudo pacman -S docker docker-compose

# LSPs & Formatters (shellcheck and shfmt from official repos)
sudo pacman -S shellcheck shfmt

# stylua, pyright, ruff from AUR
yay -S stylua pyright ruff
```

---

### Ubuntu / Raspberry Pi OS (aarch64)

```bash
# Core Tools & Build Essentials
sudo apt update
sudo apt install -y git ripgrep fd-find gcc build-essential cmake python3-pip

# Lazygit (manual install — apt version is outdated)
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_arm64.tar.gz"
tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
sudo install /tmp/lazygit /usr/local/bin

# Language Runtimes & Compilers
sudo apt install -y clangd

# Go (from go.dev — apt version is too outdated)
GO_VER=$(curl -fsSL "https://go.dev/VERSION?m=text" | head -1)
curl -Lo /tmp/go.tar.gz "https://go.dev/dl/${GO_VER}.linux-arm64.tar.gz"
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile && source ~/.profile

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# Node.js via nvm (recommended)
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
nvm install --lts

# Docker
sudo apt install -y docker.io docker-compose

# LSPs & Formatters
sudo apt install -y shellcheck

# shfmt via go install (not reliably available in Ubuntu 24.04 apt)
go install mvdan.cc/sh/v3/cmd/shfmt@latest

# stylua via cargo (apt version is outdated)
cargo install stylua

# Python LSPs
pip3 install --break-system-packages pyright ruff flake8
```

---

### Post-Install Requirements

1. **Rust:** Run `rustup default stable` after installing to initialize the toolchain.
2. **Docker:** On Linux, run `sudo usermod -aG docker $USER` so Neovim can access the Docker socket without sudo. Log out and back in for the group change to take effect.
3. **Node:** Ensure Node.js and NPM are installed — the auto-installer uses nvm. If you installed manually, make sure `node` and `npm` are in your PATH. Your Tailwind and Angular extras depend on these.
4. **Tree-sitter:** After installing Node/NPM, run `npm install -g tree-sitter-cli` to allow Neovim to compile language parsers.
5. **PATH (Ubuntu):** If `shfmt`, `stylua`, or Go tools aren't found after install, make sure `~/.cargo/bin` and `$(go env GOPATH)/bin` are in your PATH. Adding these to `~/.profile` or `~/.bashrc` and sourcing it will fix it.
