# Better Laravel React Installer

A CLI installer for the Better Laravel React starter kit.

## Overview

This repository contains a CLI tool to set up Laravel projects with React integration. It provides an interactive installer with support for multiple Node.js package managers.

## Features

- Interactive TUI installer
- Runtime selection (npm, pnpm, yarn, bun)
- Automated dependency installation
- CLI flags support
- Customizable installation workflow

## Installing the CLI Installer

### Install with one command

```bash
git clone https://github.com/MAHMETT/better-laravel-react-installer.git /tmp/better-laravel && \
cd /tmp/better-laravel && \
sudo cp better-laravel installer.sh /usr/local/bin/ && \
sudo chmod +x /usr/local/bin/better-laravel /usr/local/bin/installer.sh && \
rm -rf /tmp/better-laravel
```

### Add the path to your shell (if needed)

**Bash:**
```bash
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Zsh:**
```bash
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Fish:**
```bash
echo 'fish_add_path /usr/local/bin' >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish
```

This makes `better-laravel` available globally.

## Usage

```bash
better-laravel
```

Displays help documentation.

```bash
better-laravel new
```

Starts the interactive installer.

Example workflow:

```
~/Projects
$ better-laravel new

Enter project name: testing
```

Creates project at: `~/Projects/testing`

## Command Options

### Runtime Flags

| Flag | Description |
|------|-------------|
| `--npm` | Use npm runtime |
| `--pnpm` | Use pnpm runtime |
| `--yarn` | Use yarn runtime |
| `--bun` | Use bun runtime |

### Install Flags

| Flag | Description |
|------|-------------|
| `--install-all` | Install composer and node dependencies |
| `--install-composer` | Install composer dependencies only |
| `--install-node` | Install node dependencies only |
| `--no-install` | Skip dependency installation |

### General Flags

| Flag | Description |
|------|-------------|
| `--help` | Show help information |

## Examples

```bash
better-laravel new
better-laravel new --bun
better-laravel new --pnpm --install-node
better-laravel new --no-install
```

## Requirements

- PHP 8.1+
- Composer
- Git
- Node.js (npm, pnpm, yarn, or bun)

## License

MIT
