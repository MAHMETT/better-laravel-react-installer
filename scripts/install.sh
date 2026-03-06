#!/bin/bash

# ==============================================================================
# Better Laravel React Installer - Installation Script
# ==============================================================================
# Universal installer for bash, zsh, fish, and other POSIX shells
# ==============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

# Configuration
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
REPO_URL="https://github.com/MAHMETT/better-laravel-react-installer.git"
INSTALLER_NAME="better-laravel"

print_banner() {
    echo ""
    echo -e "${CYAN}========================================${NC}"
    echo -e "${BOLD}${CYAN}   Better Laravel React Installer${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo -e "${GRAY}Universal Shell Installation Script${NC}"
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

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Detect shell
detect_shell() {
    local shell_name=""
    
    # Check parent process
    if [ -n "$SHELL" ]; then
        shell_name=$(basename "$SHELL")
    fi
    
    # Check current shell
    if [ -z "$shell_name" ]; then
        shell_name=$(basename "$0")
    fi
    
    # Check process tree
    if [ -z "$shell_name" ] || [ "$shell_name" = "sh" ]; then
        local ppid_shell=$(ps -p $$ -o comm= 2>/dev/null || echo "")
        if [ -n "$ppid_shell" ]; then
            shell_name=$(basename "$ppid_shell")
        fi
    fi
    
    # Default to bash
    if [ -z "$shell_name" ]; then
        shell_name="bash"
    fi
    
    echo "$shell_name"
}

# Check if running as root
check_root() {
    if [ "$EUID" -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

# Check if sudo is available
check_sudo() {
    if command -v sudo &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Check if directory is writable
check_install_dir() {
    if [ -d "$INSTALL_DIR" ] && [ -w "$INSTALL_DIR" ]; then
        return 0
    elif check_sudo; then
        return 0
    else
        return 1
    fi
}

# Download installer
download_installer() {
    local temp_dir=$(mktemp -d)
    local temp_script="$temp_dir/$INSTALLER_NAME"
    
    print_step "Downloading installer from GitHub..."
    
    # Try curl first, then wget
    if command -v curl &> /dev/null; then
        if curl -fsSL -o "$temp_script" "https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/$INSTALLER_NAME" 2>/dev/null; then
            print_success "Downloaded using curl"
        else
            print_error "Failed to download with curl"
            rm -rf "$temp_dir"
            return 1
        fi
    elif command -v wget &> /dev/null; then
        if wget -q -O "$temp_script" "https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/$INSTALLER_NAME" 2>/dev/null; then
            print_success "Downloaded using wget"
        else
            print_error "Failed to download with wget"
            rm -rf "$temp_dir"
            return 1
        fi
    else
        print_error "Neither curl nor wget is available"
        rm -rf "$temp_dir"
        return 1
    fi
    
    # Make executable
    chmod +x "$temp_script"
    
    echo "$temp_script"
}

# Install to system
install_to_system() {
    local source_file="$1"
    
    print_step "Installing to $INSTALL_DIR..."
    
    if check_root; then
        # Already root
        cp "$source_file" "$INSTALL_DIR/$INSTALLER_NAME"
        chmod +x "$INSTALL_DIR/$INSTALLER_NAME"
        print_success "Installed to $INSTALL_DIR/$INSTALLER_NAME"
    elif check_sudo; then
        # Use sudo
        sudo cp "$source_file" "$INSTALL_DIR/$INSTALLER_NAME"
        sudo chmod +x "$INSTALL_DIR/$INSTALLER_NAME"
        print_success "Installed to $INSTALL_DIR/$INSTALLER_NAME (with sudo)"
    else
        print_error "Cannot write to $INSTALL_DIR"
        return 1
    fi
    
    return 0
}

# Generate shell-specific instructions
generate_shell_instructions() {
    local shell_name="$1"
    local shell_config=""
    
    case "$shell_name" in
        bash)
            shell_config="$HOME/.bashrc"
            ;;
        zsh)
            shell_config="$HOME/.zshrc"
            ;;
        fish)
            shell_config="$HOME/.config/fish/config.fish"
            ;;
        ksh)
            shell_config="$HOME/.kshrc"
            ;;
        csh|tcsh)
            shell_config="$HOME/.cshrc"
            ;;
        *)
            shell_config="$HOME/.profile"
            ;;
    esac
    
    echo "$shell_config"
}

# Check if PATH includes install directory
check_path() {
    if [[ ":$PATH:" == *":$INSTALL_DIR:"* ]]; then
        return 0
    else
        return 1
    fi
}

# Add to PATH in shell config
add_to_path() {
    local shell_name="$1"
    local shell_config=$(generate_shell_instructions "$shell_name")
    
    print_warning "$INSTALL_DIR is not in your PATH"
    echo ""
    echo -e "${CYAN}Adding $INSTALL_DIR to PATH in $shell_config${NC}"
    echo ""
    
    case "$shell_name" in
        fish)
            # Fish shell uses different syntax
            if [ -f "$shell_config" ]; then
                if ! grep -q "fish_add_path.*$INSTALL_DIR" "$shell_config" 2>/dev/null; then
                    echo "fish_add_path $INSTALL_DIR" >> "$shell_config"
                    print_success "Added to $shell_config"
                fi
            else
                mkdir -p "$(dirname "$shell_config")"
                echo "fish_add_path $INSTALL_DIR" > "$shell_config"
                print_success "Created $shell_config"
            fi
            ;;
        csh|tcsh)
            # C shell syntax
            if [ -f "$shell_config" ]; then
                if ! grep -q "set path.*$INSTALL_DIR" "$shell_config" 2>/dev/null; then
                    echo "set path = ($INSTALL_DIR \$path)" >> "$shell_config"
                    print_success "Added to $shell_config"
                fi
            else
                echo "set path = ($INSTALL_DIR \$path)" > "$shell_config"
                print_success "Created $shell_config"
            fi
            ;;
        *)
            # Bash, zsh, ksh, etc.
            if [ -f "$shell_config" ]; then
                if ! grep -q "export PATH.*$INSTALL_DIR" "$shell_config" 2>/dev/null; then
                    echo "" >> "$shell_config"
                    echo "# Better Laravel React Installer" >> "$shell_config"
                    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$shell_config"
                    print_success "Added to $shell_config"
                fi
            else
                echo "# Better Laravel React Installer" > "$shell_config"
                echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$shell_config"
                print_success "Created $shell_config"
            fi
            ;;
    esac
    
    echo ""
    print_info "Restart your shell or run: source $shell_config"
}

# Show post-installation instructions
show_post_install() {
    local shell_name="$1"
    
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${BOLD}${GREEN}   Installation Complete!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "${CYAN}The installer has been installed to:${NC}"
    echo -e "  ${GRAY}$INSTALL_DIR/$INSTALLER_NAME${NC}"
    echo ""
    
    if ! check_path; then
        echo -e "${YELLOW}Note:${NC} $INSTALL_DIR is not in your PATH"
        echo ""
        echo "To use the installer, add it to your PATH:"
        echo ""
        
        local shell_config=$(generate_shell_instructions "$shell_name")
        
        case "$shell_name" in
            fish)
                echo -e "  ${CYAN}echo 'fish_add_path $INSTALL_DIR' >> $shell_config${NC}"
                echo -e "  ${CYAN}source $shell_config${NC}"
                ;;
            csh|tcsh)
                echo -e "  ${CYAN}echo 'set path = ($INSTALL_DIR \$path)' >> $shell_config${NC}"
                echo -e "  ${CYAN}source $shell_config${NC}"
                ;;
            *)
                echo -e "  ${CYAN}echo 'export PATH=\"$INSTALL_DIR:\$PATH\"' >> $shell_config${NC}"
                echo -e "  ${CYAN}source $shell_config${NC}"
                ;;
        esac
        
        echo ""
    fi
    
    echo -e "${CYAN}Get started with:${NC}"
    echo -e "  ${GRAY}$INSTALLER_NAME --help${NC}"
    echo -e "  ${GRAY}$INSTALLER_NAME new${NC}"
    echo ""
}

# Show manual installation instructions
show_manual_install() {
    local shell_name="$1"
    
    echo ""
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${BOLD}${YELLOW}   Manual Installation Required${NC}"
    echo -e "${YELLOW}========================================${NC}"
    echo ""
    echo "Automatic installation is not possible on your system."
    echo ""
    echo -e "${CYAN}Manual installation steps:${NC}"
    echo ""
    echo "1. Clone the repository:"
    echo -e "   ${GRAY}git clone https://github.com/MAHMETT/better-laravel-react-installer.git${NC}"
    echo -e "   ${GRAY}cd better-laravel-react-installer${NC}"
    echo ""
    echo "2. Make scripts executable:"
    echo -e "   ${GRAY}chmod +x better-laravel installer.sh${NC}"
    echo ""
    echo "3. Copy to a directory in your PATH:"
    echo -e "   ${GRAY}sudo cp better-laravel /usr/local/bin/${NC}"
    echo ""
    echo "4. Verify installation:"
    echo -e "   ${GRAY}better-laravel --help${NC}"
    echo ""
    
    # Shell-specific PATH instructions
    local shell_config=$(generate_shell_instructions "$shell_name")
    
    echo -e "${CYAN}If /usr/local/bin is not in your PATH, add it:${NC}"
    echo ""
    
    case "$shell_name" in
        fish)
            echo -e "  ${GRAY}echo 'fish_add_path /usr/local/bin' >> $shell_config${NC}"
            echo -e "  ${GRAY}source $shell_config${NC}"
            ;;
        csh|tcsh)
            echo -e "  ${GRAY}echo 'set path = (/usr/local/bin \$path)' >> $shell_config${NC}"
            echo -e "  ${GRAY}source $shell_config${NC}"
            ;;
        *)
            echo -e "  ${GRAY}echo 'export PATH=\"/usr/local/bin:\$PATH\"' >> $shell_config${NC}"
            echo -e "  ${GRAY}source $shell_config${NC}"
            ;;
    esac
    
    echo ""
}

# Main installation
main() {
    print_banner
    
    # Detect shell
    local shell_name=$(detect_shell)
    print_info "Detected shell: $shell_name"
    
    # Check install directory
    if ! check_install_dir; then
        print_warning "Cannot write to $INSTALL_DIR"
        show_manual_install "$shell_name"
        exit 1
    fi
    
    # Download installer
    local temp_script=$(download_installer)
    
    if [ -z "$temp_script" ] || [ ! -f "$temp_script" ]; then
        print_error "Download failed"
        exit 1
    fi
    
    # Install to system
    if ! install_to_system "$temp_script"; then
        print_error "Installation failed"
        rm -rf "$(dirname "$temp_script")"
        exit 1
    fi
    
    # Cleanup
    rm -rf "$(dirname "$temp_script")"
    
    # Show post-installation
    show_post_install "$shell_name"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --install-dir)
            INSTALL_DIR="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: curl ... | bash -s - [options]"
            echo ""
            echo "Options:"
            echo "  --install-dir <path>  Installation directory (default: /usr/local/bin)"
            echo "  --help, -h            Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

main
