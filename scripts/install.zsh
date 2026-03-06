#!/bin/zsh

# ==============================================================================
# Better Laravel React Installer - Zsh Installation
# ==============================================================================
# Install script for zsh
# ==============================================================================

set -e

INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
INSTALLER_NAME="better-laravel"
REPO_URL="https://github.com/MAHMETT/better-laravel-react-installer"

# Colors
RED='%F{red}'
GREEN='%F{green}'
YELLOW='%F{yellow}'
BLUE='%F{blue}'
CYAN='%F{cyan}'
NC='%f'

print_banner() {
    echo ""
    echo -e "${CYAN}========================================${NC}"
    echo -e "   Better Laravel React Installer"
    echo -e "   Zsh Installation"
    echo -e "${CYAN}========================================${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}[STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_banner

# Check if zsh is running
if [ -z "$ZSH_VERSION" ]; then
    print_warning "This script is designed for zsh, but you're running $(basename $SHELL)"
    echo "Continuing anyway..."
    echo ""
fi

# Check for curl or wget
if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
    print_error "Neither curl nor wget is available"
    exit 1
fi

# Download installer
TEMP_DIR=$(mktemp -d)
TEMP_SCRIPT="$TEMP_DIR/$INSTALLER_NAME"

print_step "Downloading installer..."

if command -v curl &> /dev/null; then
    if curl -fsSL -o "$TEMP_SCRIPT" "https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/$INSTALLER_NAME" 2>/dev/null; then
        print_success "Downloaded using curl"
    else
        print_error "Failed to download with curl"
        rm -rf "$TEMP_DIR"
        exit 1
    fi
else
    if wget -q -O "$TEMP_SCRIPT" "https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/$INSTALLER_NAME" 2>/dev/null; then
        print_success "Downloaded using wget"
    else
        print_error "Failed to download with wget"
        rm -rf "$TEMP_DIR"
        exit 1
    fi
fi

# Make executable
chmod +x "$TEMP_SCRIPT"

# Install to system
print_step "Installing to $INSTALL_DIR..."

if [ -w "$INSTALL_DIR" ]; then
    cp "$TEMP_SCRIPT" "$INSTALL_DIR/$INSTALLER_NAME"
    chmod +x "$INSTALL_DIR/$INSTALLER_NAME"
    print_success "Installed to $INSTALL_DIR/$INSTALLER_NAME"
elif command -v sudo &> /dev/null; then
    sudo cp "$TEMP_SCRIPT" "$INSTALL_DIR/$INSTALLER_NAME"
    sudo chmod +x "$INSTALL_DIR/$INSTALLER_NAME"
    print_success "Installed to $INSTALL_DIR/$INSTALLER_NAME (with sudo)"
else
    print_error "Cannot write to $INSTALL_DIR"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEMP_DIR"

# Add to zsh path
ZSH_CONFIG="${ZDOTDIR:-$HOME}/.zshrc"

print_step "Configuring zsh..."

if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    # Create config directory if it doesn't exist
    mkdir -p "$(dirname "$ZSH_CONFIG")"
    
    # Add to zsh config
    if [ -f "$ZSH_CONFIG" ]; then
        if ! grep -q "export PATH.*$INSTALL_DIR" "$ZSH_CONFIG" 2>/dev/null; then
            echo "" >> "$ZSH_CONFIG"
            echo "# Better Laravel React Installer" >> "$ZSH_CONFIG"
            echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$ZSH_CONFIG"
            print_success "Added to $ZSH_CONFIG"
        else
            print_info "$INSTALL_DIR is already in PATH configuration"
        fi
    else
        echo "# Better Laravel React Installer" > "$ZSH_CONFIG"
        echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$ZSH_CONFIG"
        print_success "Created $ZSH_CONFIG"
    fi
else
    print_info "$INSTALL_DIR is already in PATH"
fi

# Show completion message
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "   Installation Complete!"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${CYAN}The installer has been installed to:${NC}"
echo -e "   $INSTALL_DIR/$INSTALLER_NAME"
echo ""
echo -e "${CYAN}Get started with:${NC}"
echo -e "   $INSTALLER_NAME --help"
echo -e "   $INSTALLER_NAME new"
echo ""
echo -e "${YELLOW}Note:${NC} Restart your zsh shell or run:"
echo -e "   ${CYAN}source $ZSH_CONFIG${NC}"
echo ""
