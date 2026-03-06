# Better Laravel React Installer - Fish Installer
# Downloads and installs the better-laravel CLI globally

set -l INSTALL_DIR "/usr/local/bin"
set -l RAW_URL "https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/refs/heads/main"

# Colors
set -l RED (set_color red)
set -l GREEN (set_color green)
set -l YELLOW (set_color yellow)
set -l CYAN (set_color cyan)
set -l GRAY (set_color -d)
set -l NC (set_color normal)

echo ""
echo "$CYAN========================================$NC"
echo "$GREEN   Better Laravel React Installer$NC"
echo "$CYAN========================================$NC"
echo ""

# Check for curl/wget
if not command -q curl; and not command -q wget
    echo "$RED✖$NC Error: curl or wget is required"
    exit 1
end

# Download
echo "$GREEN[STEP]$NC Downloading better-laravel..."
set -l TEMP_FILE (mktemp)

if command -q curl
    if not curl -fsSL -o "$TEMP_FILE" "$RAW_URL/better-laravel" 2>/dev/null
        echo "$RED✖$NC Failed to download"
        exit 1
    end
else if command -q wget
    if not wget -q -O "$TEMP_FILE" "$RAW_URL/better-laravel"
        echo "$RED✖$NC Failed to download"
        exit 1
    end
end

chmod +x "$TEMP_FILE"

# Install
echo "$GREEN[STEP]$NC Installing to $INSTALL_DIR..."

if test -w "$INSTALL_DIR"
    mv "$TEMP_FILE" "$INSTALL_DIR/better-laravel"
    echo "  $GREEN✔$NC Installed successfully"
else if command -q sudo
    sudo mv "$TEMP_FILE" "$INSTALL_DIR/better-laravel"
    echo "  $GREEN✔$NC Installed successfully (with sudo)"
else
    echo "$RED✖$NC Cannot write to $INSTALL_DIR"
    exit 1
end

# Check PATH
set -l in_path 0
for dir in $PATH
    if test "$dir" = "$INSTALL_DIR"
        set in_path 1
        break
    end
end

if test $in_path -eq 0
    echo ""
    echo "$YELLOW⚠$NC $INSTALL_DIR is not in your PATH"
    echo ""
    echo "Add to your fish config:"
    echo "$CYAN  fish_add_path $INSTALL_DIR$NC"
    echo ""
end

echo ""
echo "$GREEN========================================$NC"
echo "$GREEN   Installation Complete!$NC"
echo "$GREEN========================================$NC"
echo ""
echo "$CYAN Get started:$NC"
echo ""
echo "$GRAY  better-laravel --help$NC"
echo "$GRAY  better-laravel new$NC"
echo ""
