# Installation

Install the Better Laravel React Installer globally or use it locally.

## Quick Install

### Bash (Universal)

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/refs/heads/main/scripts/install.sh | bash
```

### Zsh

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/refs/heads/main/scripts/install.zsh | zsh
```

### Fish

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/refs/heads/main/scripts/install.fish | fish
```

## Installation Methods

For detailed shell-specific instructions, see [Shell Installation Guide](./07-shell-installation.md).

### Option 1: Universal Script (Recommended)

Automatic installation with PATH configuration:

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/scripts/install.sh | bash
```

This will:
- Download the latest installer
- Install to `/usr/local/bin`
- Configure your shell's PATH if needed

### Option 2: Manual Installation

Clone and install manually:

```bash
# Clone the repository
git clone https://github.com/MAHMETT/better-laravel-react-installer.git
cd better-laravel-react-installer

# Make scripts executable
chmod +x better-laravel installer.sh

# Move to global path
sudo mv better-laravel /usr/local/bin/
```

### Option 3: Local Use

Use without installing globally:

```bash
# Clone the repository
git clone https://github.com/MAHMETT/better-laravel-react-installer.git
cd better-laravel-react-installer

# Run directly
./better-laravel new
```

## Verify Installation

Check that the command is available:

```bash
better-laravel --help
```

Expected output:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Better Laravel React Installer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

USAGE
  better-laravel new [options]
...
```

## Shell Configuration

After installation, ensure your shell can find the command:

### Bash

```bash
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Zsh

```bash
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Fish

```fish
fish_add_path /usr/local/bin
```

## Prerequisites

Before installing, ensure you have:

| Tool | Install Command |
|------|-----------------|
| Git | `sudo apt install git` (Ubuntu) / `brew install git` (macOS) |
| Curl | `sudo apt install curl` (Ubuntu) / `brew install curl` (macOS) |

The installer itself has no runtime dependencies. PHP, Composer, and Node.js are only required when running the installer to create Laravel projects.

## Next Steps

- [Usage Guide](./03-usage.md) — Start using the installer
- [Shell Installation](./07-shell-installation.md) — Detailed shell-specific instructions
- [Troubleshooting](./05-troubleshooting.md) — Common installation issues
