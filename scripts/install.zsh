#!/bin/zsh
# Better Laravel React Installer - Zsh Installer
# Downloads and installs the better-laravel CLI globally

set -e

INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
RAW_URL="https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/refs/heads/main"

# Colors
RED='%F{red}'
GREEN='%F{green}'
YELLOW='%F{yellow}'
CYAN='%F{cyan}'
GRAY='%F{white}'
NC='%f'

echo ""
echo "${CYAN}========================================${NC}"
echo "${GREEN}   Better Laravel React Installer${NC}"
echo "${CYAN}========================================${NC}"
echo ""

# Check for curl/wget
if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
    echo "${RED}✖${NC} Error: curl or wget is required"
    exit 1
fi

# Download
echo "${GREEN}[STEP]${NC} Downloading better-laravel..."
TEMP_FILE=$(mktemp)

if command -v curl >/dev/null 2>&1; then
    curl -fsSL -o "$TEMP_FILE" "$RAW_URL/better-laravel" 2>/dev/null || {
        echo "${RED}✖${NC} Failed to download"
        exit 1
    }
else
    wget -q -O "$TEMP_FILE" "$RAW_URL/better-laravel" || {
        echo "${RED}✖${NC} Failed to download"
        exit 1
    }
fi

chmod +x "$TEMP_FILE"

# Install
echo "${GREEN}[STEP]${NC} Installing to $INSTALL_DIR..."

if [ -w "$INSTALL_DIR" ]; then
    mv "$TEMP_FILE" "$INSTALL_DIR/better-laravel"
    echo "  ${GREEN}✔${NC} Installed successfully"
elif command -v sudo >/dev/null 2>&1; then
    sudo mv "$TEMP_FILE" "$INSTALL_DIR/better-laravel"
    echo "  ${GREEN}✔${NC} Installed successfully (with sudo)"
else
    echo "${RED}✖${NC} Cannot write to $INSTALL_DIR"
    exit 1
fi

# Check PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "${YELLOW}⚠${NC} $INSTALL_DIR is not in your PATH"
    echo ""
    echo "Add to your shell config:"
    echo "${CYAN}  echo 'export PATH=\"$INSTALL_DIR:\$PATH\"' >> ~/.zshrc${NC}"
    echo "${CYAN}  source ~/.zshrc${NC}"
    echo ""
fi

echo ""
echo "${GREEN}========================================${NC}"
echo "${GREEN}   Installation Complete!${NC}"
echo "${GREEN}========================================${NC}"
echo ""
echo "${CYAN}Get started:${NC}"
echo ""
echo "${GRAY}  better-laravel --help${NC}"
echo "${GRAY}  better-laravel new${NC}"
echo ""
