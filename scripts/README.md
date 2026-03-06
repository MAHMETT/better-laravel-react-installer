# Shell Installation Scripts

Platform-specific installation scripts for different shells.

## Available Scripts

| Script | Shell | Description |
|--------|-------|-------------|
| `install.sh` | Bash/POSIX | Universal bash installer |
| `install.zsh` | Zsh | Zsh-specific installer |
| `install.fish` | Fish | Fish shell installer |

## Usage

### Bash (Universal)

```bash
# Download and run
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/scripts/install.sh | bash

# Or with custom install directory
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/scripts/install.sh | bash -s -- --install-dir /opt/bin
```

### Zsh

```bash
# Download and run with zsh
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/scripts/install.zsh | zsh
```

### Fish

```bash
# Download and run with fish
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/scripts/install.fish | fish
```

## Manual Installation

If automatic installation doesn't work:

```bash
# Clone repository
git clone https://github.com/MAHMETT/better-laravel-react-installer.git
cd better-laravel-react-installer

# Make executable
chmod +x better-laravel

# Copy to PATH
sudo cp better-laravel /usr/local/bin/
```

## Shell-Specific Configuration

### Bash

Add to `~/.bashrc`:

```bash
export PATH="/usr/local/bin:$PATH"
```

### Zsh

Add to `~/.zshrc`:

```bash
export PATH="/usr/local/bin:$PATH"
```

### Fish

Add to `~/.config/fish/config.fish`:

```fish
fish_add_path /usr/local/bin
```

## Verification

After installation, verify:

```bash
better-laravel --help
```

## Troubleshooting

### Command Not Found

Ensure the install directory is in your PATH:

```bash
echo $PATH
```

### Permission Denied

Use sudo or install to a writable directory:

```bash
curl -fsSL https://.../install.sh | bash -s -- --install-dir $HOME/.local/bin
```

Then add `$HOME/.local/bin` to your PATH.
