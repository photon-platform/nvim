#!/usr/bin/env bash
# ==============================================================================
# install_neovim.sh - Automated installer and setup for Neovim
# (Base system and Python environment are initialized via ~/.photon/init_pop.sh)
# ==============================================================================
set -euo pipefail

echo "========================================================"
echo " Starting Neovim Installation & Setup"
echo "========================================================"

# --- 1. System Dependencies via APT (Editor & LSP Support) ---
echo ""
echo "[1/4] Installing system dependencies via apt..."
sudo apt update
sudo apt install -y \
  build-essential \
  curl \
  tar \
  gzip \
  unzip \
  wget \
  ripgrep \
  fd-find \
  xclip \
  openjdk-17-jdk \
  python3-venv

# Ensure 'fd' command is available if fd-find provides fdfind
mkdir -p "${HOME}/.local/bin"
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  ln -sf "$(command -v fdfind)" "${HOME}/.local/bin/fd"
fi

# Ensure Node.js and npm (required by Mason for LSP installation) are available.
# Note: When NodeSource repo is configured, 'nodejs' includes npm and conflicts
# with the standalone Ubuntu/Debian 'npm' package.
if ! command -v node >/dev/null 2>&1; then
  echo "Installing Node.js..."
  sudo apt install -y nodejs
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "Installing npm..."
  sudo apt install -y npm
fi

echo "System packages installed successfully."

# --- 2. Neovim Binary Installation ---
echo ""
echo "[2/4] Downloading and installing latest Neovim release..."
TMP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_DIR}"' EXIT

NVIM_TARBALL_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
echo "Downloading Neovim from ${NVIM_TARBALL_URL}..."
curl -sSL "${NVIM_TARBALL_URL}" -o "${TMP_DIR}/nvim-linux-x86_64.tar.gz"

echo "Extracting to /opt..."
sudo rm -rf /opt/nvim-linux-x86_64 /opt/nvim
sudo tar -C /opt -xzf "${TMP_DIR}/nvim-linux-x86_64.tar.gz"
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

echo "Neovim installed to /opt/nvim-linux-x86_64 and symlinked to /usr/local/bin/nvim."

# --- 3. Neovim-Specific Python Tooling (via uv) ---
# Note: Base Python and uv are installed via ~/.photon/init/python.sh
echo ""
echo "[3/4] Installing Neovim-specific Python tools via uv..."
if ! command -v uv >/dev/null 2>&1; then
  echo "Warning: 'uv' not found in PATH. Please run ~/.photon/init/python.sh first." >&2
else
  # Ensure ~/.local/bin is in PATH for current session
  export PATH="${HOME}/.local/bin:${PATH}"

  # Neovim Python 3 provider and DAP debugpy
  echo "Installing pynvim provider and debugpy..."
  uv tool install --with debugpy pynvim --force
  uv tool install debugpy --force

  # Sphinx / reStructuredText language server (esbonio)
  echo "Installing esbonio LSP..."
  uv tool install esbonio --force
fi

# --- 4. Bootstrap Neovim Plugins ---
echo ""
echo "[4/4] Bootstrapping Neovim plugins via lazy.nvim..."
nvim --headless "+Lazy! sync" +qa || true

echo ""
echo "========================================================"
echo " Installation Complete! Environment Verification:"
echo "========================================================"
echo "Neovim:     $(nvim --version | head -n 1)"
echo "Node.js:    $(node -v 2>/dev/null || echo 'N/A')"
echo "npm:        $(npm -v 2>/dev/null || echo 'N/A')"
echo "Java:       $(java --version 2>/dev/null | head -n 1 || echo 'N/A')"
echo "uv:         $(uv --version 2>/dev/null || echo 'N/A')"
echo "Python:     $(python3 --version 2>/dev/null || echo 'N/A')"
echo "pynvim:     ${HOME}/.local/share/uv/tools/pynvim/bin/python"
echo "debugpy:    $(which debugpy 2>/dev/null || echo 'N/A')"
echo "esbonio:    $(which esbonio 2>/dev/null || echo 'N/A')"
echo "========================================================"
