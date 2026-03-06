# Better Laravel React Installer - Fish Shell Installation
# =================================================================
# Install script for fish shell
# =================================================================

set -e

set -l INSTALL_DIR "/usr/local/bin"
set -l INSTALLER_NAME "better-laravel"
set -l REPO_URL "https://github.com/MAHMETT/better-laravel-react-installer"

# Colors
set -l RED \033[0;31m
set -l GREEN \033[0;32m
set -l YELLOW \033[1;33m
set -l BLUE \033[0;34m
set -l CYAN \033[0;36m
set -l NC \033[0m

echo ""
echo -e "$CYAN========================================$NC"
echo -e "   Better Laravel React Installer"
echo -e "   Fish Shell Installation"
echo -e "$CYAN========================================$NC"
echo ""

# Check if fish is installed
if not command -v fish &> /dev/null
    echo -e "$RED✗ Fish shell is not installed$NC"
    echo ""
    echo "Install fish first:"
    echo "  Ubuntu/Debian: sudo apt install fish"
    echo "  macOS (Homebrew): brew install fish"
    echo "  Fedora: sudo dnf install fish"
    exit 1
end

echo -e "$GREEN✓$NC Fish shell detected"

# Check for curl or wget
if not command -v curl &> /dev/null; and not command -v wget &> /dev/null
    echo -e "$RED✗ Neither curl nor wget is available$NC"
    exit 1
end

# Download installer
set -l TEMP_DIR (mktemp -d)
set -l TEMP_SCRIPT "$TEMP_DIR/$INSTALLER_NAME"

echo -e "$GREEN[STEP]$NC Downloading installer..."

if command -v curl &> /dev/null
    if curl -fsSL -o "$TEMP_SCRIPT" "https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/$INSTALLER_NAME" 2>/dev/null
        echo -e "$GREEN✓$NC Downloaded using curl"
    else
        echo -e "$RED✗$NC Failed to download with curl"
        rm -rf "$TEMP_DIR"
        exit 1
    end
else
    if wget -q -O "$TEMP_SCRIPT" "https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/$INSTALLER_NAME" 2>/dev/null
        echo -e "$GREEN✓$NC Downloaded using wget"
    else
        echo -e "$RED✗$NC Failed to download with wget"
        rm -rf "$TEMP_DIR"
        exit 1
    end
end

# Make executable
chmod +x "$TEMP_SCRIPT"

# Install to system
echo -e "$GREEN[STEP]$NC Installing to $INSTALL_DIR..."

if [ -w "$INSTALL_DIR" ]
    cp "$TEMP_SCRIPT" "$INSTALL_DIR/$INSTALLER_NAME"
    chmod +x "$INSTALL_DIR/$INSTALLER_NAME"
    echo -e "$GREEN✓$NC Installed to $INSTALL_DIR/$INSTALLER_NAME"
else if command -v sudo &> /dev/null
    sudo cp "$TEMP_SCRIPT" "$INSTALL_DIR/$INSTALLER_NAME"
    sudo chmod +x "$INSTALL_DIR/$INSTALLER_NAME"
    echo -e "$GREEN✓$NC Installed to $INSTALL_DIR/$INSTALLER_NAME (with sudo)"
else
    echo -e "$RED✗$NC Cannot write to $INSTALL_DIR"
    rm -rf "$TEMP_DIR"
    exit 1
end

# Cleanup
rm -rf "$TEMP_DIR"

# Add to fish path
set -l FISH_CONFIG "$HOME/.config/fish/config.fish"

echo -e "$GREEN[STEP]$NC Configuring fish shell..."

if not string match -q -- "*$INSTALL_DIR*" (string split ':' $PATH)
    # Create config directory if it doesn't exist
    mkdir -p (dirname "$FISH_CONFIG")
    
    # Add to fish config
    if test -f "$FISH_CONFIG"
        if not grep -q "fish_add_path.*$INSTALL_DIR" "$FISH_CONFIG" 2>/dev/null
            echo "" >> "$FISH_CONFIG"
            echo "# Better Laravel React Installer" >> "$FISH_CONFIG"
            echo "fish_add_path $INSTALL_DIR" >> "$FISH_CONFIG"
            echo -e "$GREEN✓$NC Added to $FISH_CONFIG"
        end
    else
        echo "# Better Laravel React Installer" > "$FISH_CONFIG"
        echo "fish_add_path $INSTALL_DIR" >> "$FISH_CONFIG"
        echo -e "$GREEN✓$NC Created $FISH_CONFIG"
    end
else
    echo -e "$BLUEℹ$NC $INSTALL_DIR is already in PATH"
end

# Show completion message
echo ""
echo -e "$GREEN========================================$NC"
echo -e "   Installation Complete!"
echo -e "$GREEN========================================$NC"
echo ""
echo -e "$CYAN The installer has been installed to:$NC"
echo -e "   $INSTALL_DIR/$INSTALLER_NAME"
echo ""
echo -e "$CYAN Get started with:$NC"
echo -e "   $INSTALLER_NAME --help"
echo -e "   $INSTALLER_NAME new"
echo ""
echo -e "$YELLOW Note:$NC Restart your fish shell or run:"
echo -e "   $CYAN source $FISH_CONFIG$NC"
echo ""
