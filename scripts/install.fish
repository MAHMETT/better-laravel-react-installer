# Better Laravel React Installer - Fish Shell Installation
# =================================================================
# Install script for fish shell
# =================================================================

set -l INSTALL_DIR "/usr/local/bin"
set -l INSTALLER_NAME "better-laravel"
set -l RAW_URL "https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/refs/heads/main"

# ANSI escape codes
set -l RED "\e[31m"
set -l GREEN "\e[32m"
set -l YELLOW "\e[33m"
set -l BLUE "\e[34m"
set -l CYAN "\e[36m"
set -l BOLD "\e[1m"
set -l DIM "\e[2m"
set -l RESET "\e[0m"

# Print functions
function print_banner
    printf '\n'
    printf '%b%s%b\n' "$CYAN" "========================================" "$RESET"
    printf '%b%s%b\n' "$BOLD$CYAN" "   Better Laravel React Installer" "$RESET"
    printf '%b%s%b\n' "$CYAN" "========================================" "$RESET"
    printf '%b%s%b\n' "$DIM" "Universal Shell Installation Script" "$RESET"
    printf '\n'
end

function print_step -a msg
    printf '%b[STEP]%b %s\n' "$GREEN" "$RESET" "$msg"
end

function print_success -a msg
    printf '%b✓%b %s\n' "$GREEN" "$RESET" "$msg"
end

function print_error -a msg
    printf '%b✗%b %s\n' "$RED" "$RESET" "$msg"
end

function print_warning -a msg
    printf '%b⚠%b %s\n' "$YELLOW" "$RESET" "$msg"
end

function print_info -a msg
    printf '%bℹ%b %s\n' "$BLUE" "$RESET" "$msg"
end

function print_dim -a msg
    printf '%b%s%b\n' "$DIM" "$msg" "$RESET"
end

function print_cyan -a msg
    printf '%b%s%b\n' "$CYAN" "$msg" "$RESET"
end

# Detect shell from parent process
function detect_shell
    set -l shell_name "fish"
    
    if command -q ps
        set -l parent_pid (ps -o ppid= -p $process_id 2>/dev/null | string trim)
        if test -n "$parent_pid"
            set -l parent_shell (ps -o comm= -p "$parent_pid" 2>/dev/null)
            if test -n "$parent_shell"
                set shell_name (basename "$parent_shell")
            end
        end
    end
    
    if test -n "$SHELL"
        set -l shell_from_env (basename "$SHELL")
        switch "$shell_from_env"
            case bash zsh fish ksh csh tcsh sh
                set shell_name "$shell_from_env"
        end
    end
    
    echo "$shell_name"
end

function check_root
    test "$EUID" -eq 0
end

function check_sudo
    command -q sudo
end

function check_install_dir
    if test -d "$INSTALL_DIR"
        if test -w "$INSTALL_DIR"
            return 0
        end
    end
    
    if check_sudo
        return 0
    end
    
    return 1
end

function download_installer
    set -l temp_dir (mktemp -d)
    set -l temp_script "$temp_dir/$INSTALLER_NAME"
    set -l download_url "$RAW_URL/$INSTALLER_NAME"
    
    print_step "Downloading installer from GitHub..."
    
    if command -q curl
        print_dim "Using curl to download from: $download_url"
        if curl -fsSL -o "$temp_script" "$download_url" ^/dev/null
            print_success "Downloaded using curl"
        else
            print_error "Failed to download with curl"
            print_dim "URL: $download_url"
            rm -rf "$temp_dir"
            return 1
        end
    else if command -q wget
        print_dim "Using wget to download from: $download_url"
        if wget -q -O "$temp_script" "$download_url" ^/dev/null
            print_success "Downloaded using wget"
        else
            print_error "Failed to download with wget"
            rm -rf "$temp_dir"
            return 1
        end
    else
        print_error "Neither curl nor wget is available"
        rm -rf "$temp_dir"
        return 1
    end
    
    if not test -f "$temp_script"
        print_error "Downloaded file is missing"
        rm -rf "$temp_dir"
        return 1
    end
    
    if not test -s "$temp_script"
        print_error "Downloaded file is empty"
        rm -rf "$temp_dir"
        return 1
    end
    
    chmod +x "$temp_script"
    echo "$temp_script"
end

function install_to_system -a source_file
    print_step "Installing to $INSTALL_DIR..."
    
    if check_root
        cp "$source_file" "$INSTALL_DIR/$INSTALLER_NAME"
        chmod +x "$INSTALL_DIR/$INSTALLER_NAME"
        print_success "Installed to $INSTALL_DIR/$INSTALLER_NAME"
    else if check_sudo
        sudo cp "$source_file" "$INSTALL_DIR/$INSTALLER_NAME"
        sudo chmod +x "$INSTALL_DIR/$INSTALLER_NAME"
        print_success "Installed to $INSTALL_DIR/$INSTALLER_NAME (with sudo)"
    else
        print_error "Cannot write to $INSTALL_DIR"
        return 1
    end
    
    return 0
end

function get_shell_config -a shell_name
    set -l shell_config ""
    
    switch "$shell_name"
        case bash
            set shell_config "$HOME/.bashrc"
        case zsh
            set shell_config "$HOME/.zshrc"
        case fish
            set shell_config "$HOME/.config/fish/config.fish"
        case ksh
            set shell_config "$HOME/.kshrc"
        case csh tcsh
            set shell_config "$HOME/.cshrc"
        case '*'
            set shell_config "$HOME/.profile"
    end
    
    echo "$shell_config"
end

function check_path
    for dir in $PATH
        if test "$dir" = "$INSTALL_DIR"
            return 0
        end
    end
    return 1
end

function add_to_path -a shell_name
    set -l shell_config (get_shell_config "$shell_name")
    
    print_warning "$INSTALL_DIR is not in your PATH"
    echo ""
    print_cyan "Adding $INSTALL_DIR to PATH in $shell_config"
    echo ""
    
    mkdir -p (dirname "$shell_config")
    
    switch "$shell_name"
        case fish
            if test -f "$shell_config"
                if not grep -q "fish_add_path.*$INSTALL_DIR" "$shell_config" ^/dev/null
                    echo "" >> "$shell_config"
                    echo "# Better Laravel React Installer" >> "$shell_config"
                    echo "fish_add_path $INSTALL_DIR" >> "$shell_config"
                    print_success "Added to $shell_config"
                end
            else
                echo "# Better Laravel React Installer" > "$shell_config"
                echo "fish_add_path $INSTALL_DIR" > "$shell_config"
                print_success "Created $shell_config"
            end
        case csh tcsh
            if test -f "$shell_config"
                if not grep -q "set path.*$INSTALL_DIR" "$shell_config" ^/dev/null
                    echo "" >> "$shell_config"
                    echo "# Better Laravel React Installer" >> "$shell_config"
                    echo "set path = ($INSTALL_DIR \$path)" >> "$shell_config"
                    print_success "Added to $shell_config"
                end
            else
                echo "# Better Laravel React Installer" > "$shell_config"
                echo "set path = ($INSTALL_DIR \$path)" > "$shell_config"
                print_success "Created $shell_config"
            end
        case '*'
            if test -f "$shell_config"
                if not grep -q "export PATH.*$INSTALL_DIR" "$shell_config" ^/dev/null
                    echo "" >> "$shell_config"
                    echo "# Better Laravel React Installer" >> "$shell_config"
                    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$shell_config"
                    print_success "Added to $shell_config"
                end
            else
                echo "# Better Laravel React Installer" > "$shell_config"
                echo "export PATH=\"$INSTALL_DIR:\$PATH\"" > "$shell_config"
                print_success "Created $shell_config"
            end
    end
    
    echo ""
    print_info "Restart your shell or run: source $shell_config"
end

function show_post_install -a shell_name
    echo ""
    printf '%b%s%b\n' "$GREEN" "========================================" "$RESET"
    printf '%b%s%b\n' "$BOLD$GREEN" "   Installation Complete!" "$RESET"
    printf '%b%s%b\n' "$GREEN" "========================================" "$RESET"
    echo ""
    print_cyan "The installer has been installed to:"
    echo ""
    print_dim "  $INSTALL_DIR/$INSTALLER_NAME"
    echo ""
    
    if not check_path
        printf '%bNote:%b %s is not in your PATH\n' "$YELLOW" "$RESET" "$INSTALL_DIR"
        echo ""
        echo "To use the installer, add it to your PATH:"
        echo ""
        
        set -l shell_config (get_shell_config "$shell_name")
        
        switch "$shell_name"
            case fish
                print_cyan "  echo 'fish_add_path $INSTALL_DIR' >> $shell_config"
                print_cyan "  source $shell_config"
            case csh tcsh
                print_cyan "  echo 'set path = ($INSTALL_DIR \$path)' >> $shell_config"
                print_cyan "  source $shell_config"
            case '*'
                print_cyan "  echo 'export PATH=\"$INSTALL_DIR:\$PATH\"' >> $shell_config"
                print_cyan "  source $shell_config"
        end
        
        echo ""
    end
    
    print_cyan "Get started with:"
    echo ""
    print_dim "  $INSTALLER_NAME --help"
    print_dim "  $INSTALLER_NAME new"
    echo ""
end

function show_manual_install -a shell_name
    echo ""
    printf '%b%s%b\n' "$YELLOW" "========================================" "$RESET"
    printf '%b%s%b\n' "$BOLD$YELLOW" "   Manual Installation Required" "$RESET"
    printf '%b%s%b\n' "$YELLOW" "========================================" "$RESET"
    echo ""
    echo "Automatic installation is not possible on your system."
    echo ""
    print_cyan "Manual installation steps:"
    echo ""
    echo "1. Clone the repository:"
    print_dim "   git clone https://github.com/MAHMETT/better-laravel-react-installer.git"
    print_dim "   cd better-laravel-react-installer"
    echo ""
    echo "2. Make scripts executable:"
    print_dim "   chmod +x better-laravel installer.sh"
    echo ""
    echo "3. Copy to a directory in your PATH:"
    print_dim "   sudo cp better-laravel /usr/local/bin/"
    echo ""
    echo "4. Verify installation:"
    print_dim "   better-laravel --help"
    echo ""
    
    set -l shell_config (get_shell_config "$shell_name")
    
    print_cyan "If /usr/local/bin is not in your PATH, add it:"
    echo ""
    
    switch "$shell_name"
        case fish
            print_dim "  echo 'fish_add_path /usr/local/bin' >> $shell_config"
            print_dim "  source $shell_config"
        case csh tcsh
            print_dim "  echo 'set path = (/usr/local/bin \$path)' >> $shell_config"
            print_dim "  source $shell_config"
        case '*'
            print_dim "  echo 'export PATH=\"/usr/local/bin:\$PATH\"' >> $shell_config"
            print_dim "  source $shell_config"
    end
    
    echo ""
end

function main
    print_banner
    
    set -l shell_name (detect_shell)
    print_info "Detected shell: $shell_name"
    
    if not check_install_dir
        print_warning "Cannot write to $INSTALL_DIR"
        show_manual_install "$shell_name"
        exit 1
    end
    
    set -l temp_script
    set temp_script (download_installer)
    
    if test -z "$temp_script"
        print_error "Download failed"
        exit 1
    end
    
    if not test -f "$temp_script"
        print_error "Downloaded file not found"
        exit 1
    end
    
    if not install_to_system "$temp_script"
        print_error "Installation failed"
        rm -rf (dirname "$temp_script")
        exit 1
    end
    
    rm -rf (dirname "$temp_script")
    
    if not check_path
        add_to_path "$shell_name"
    end
    
    show_post_install "$shell_name"
end

# Parse arguments
for arg in $argv
    switch "$arg"
        case "--install-dir"
            set INSTALL_DIR $argv[(contains -i -- "$arg" $argv) + 1]
        case "--help" "-h"
            echo "Usage: curl ... | fish -c - [options]"
            echo ""
            echo "Options:"
            echo "  --install-dir <path>  Installation directory (default: /usr/local/bin)"
            echo "  --help, -h            Show this help"
            exit 0
        case '*'
            echo "Unknown option: $arg"
            echo "Use --help for usage information"
            exit 1
    end
end

main
