#!/bin/bash
# Better Laravel React Installer - Bash/Zsh Installer
# Downloads and installs the better-laravel CLI globally

set -e

INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
RAW_URL="https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/refs/heads/main"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}   Better Laravel React Installer${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Check for curl/wget
if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
    echo -e "${RED}✖${NC} Error: curl or wget is required"
    exit 1
fi

# Download
echo -e "${GREEN}[STEP]${NC} Downloading better-laravel..."
TEMP_FILE=$(mktemp)

if command -v curl >/dev/null 2>&1; then
    curl -fsSL -o "$TEMP_FILE" "$RAW_URL/better-laravel" 2>/dev/null || {
        echo -e "${RED}✖${NC} Failed to download"
        exit 1
    }
else
    wget -q -O "$TEMP_FILE" "$RAW_URL/better-laravel" || {
        echo -e "${RED}✖${NC} Failed to download"
        exit 1
    }
fi

chmod +x "$TEMP_FILE"

# Install
echo -e "${GREEN}[STEP]${NC} Installing to $INSTALL_DIR..."

if [ -w "$INSTALL_DIR" ]; then
    mv "$TEMP_FILE" "$INSTALL_DIR/better-laravel"
    echo -e "  ${GREEN}✔${NC} Installed successfully"
elif command -v sudo >/dev/null 2>&1; then
    sudo mv "$TEMP_FILE" "$INSTALL_DIR/better-laravel"
    echo -e "  ${GREEN}✔${NC} Installed successfully (with sudo)"
else
    echo -e "${RED}✖${NC} Cannot write to $INSTALL_DIR"
    exit 1
fi

# Check PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo -e "${YELLOW}⚠${NC} $INSTALL_DIR is not in your PATH"
    echo ""
    echo "Add to your shell config:"
    echo -e "  ${CYAN}echo 'export PATH=\"$INSTALL_DIR:\$PATH\"' >> ~/.bashrc${NC}"
    echo -e "  ${CYAN}source ~/.bashrc${NC}"
    echo ""
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Installation Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${CYAN}Get started:${NC}"
echo ""
echo -e "  ${GRAY}better-laravel --help${NC}"
echo -e "  ${GRAY}better-laravel new${NC}"
echo ""
