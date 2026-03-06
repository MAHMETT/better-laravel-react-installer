# Better Laravel React Installer

A modern, interactive CLI installer for the Better Laravel React starter kit.

## Overview

Better Laravel React is a Laravel starter kit with React integration. This installer provides an interactive CLI to set up new projects with customizable options.

## Features

- Interactive TUI with clean terminal interface
- CLI flags for automation
- Automatic dependency checking
- Branch and runtime selection
- Fail-safe installation with clear error messages

## Installation

### Bash/Zsh

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/refs/heads/main/scripts/install.sh | bash
```

### Fish Shell

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/refs/heads/main/scripts/install.fish | fish
```

### Zsh

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/refs/heads/main/scripts/install.zsh | zsh
```

### Manual Installation

```bash
git clone https://github.com/MAHMETT/better-laravel-react-installer.git
cd better-laravel-react-installer
chmod +x installer.sh
sudo mv installer.sh /usr/local/bin/better-laravel
```

## Usage

### Interactive Mode

```bash
better-laravel
```

Displays help documentation.

### Create New Project

```bash
better-laravel new
```

The installer will:

1. Prompt for project name
2. Select branch
3. Choose runtime
4. Select dependencies to install

Example workflow:

```
~/Projects
$ better-laravel new

Enter project name: my-app

[Installation proceeds...]
```

Creates project at: `~/Projects/my-app`

## Command Options

### Runtime Options

| Flag | Description |
|------|-------------|
| `--npm` | Use npm for node dependencies |
| `--pnpm` | Use pnpm for node dependencies |
| `--yarn` | Use yarn for node dependencies |
| `--bun` | Use bun for node dependencies |

### Install Options

| Flag | Description |
|------|-------------|
| `--install-all` | Install composer and node dependencies |
| `--install-composer` | Install composer dependencies only |
| `--install-node` | Install node dependencies only |
| `--no-install` | Skip dependency installation |

### General Options

| Flag | Description |
|------|-------------|
| `--branch <name>` | Specify branch |
| `--help` | Show help message |

## Examples

```bash
# Interactive installation
better-laravel new

# Use specific runtime
better-laravel new --bun

# Node dependencies only
better-laravel new --pnpm --install-node

# Skip all dependencies
better-laravel new --no-install

# Specify branch
better-laravel new --branch main --bun
```

## Requirements

- PHP 8.1+
- Composer
- Git
- Node.js (npm, pnpm, yarn, or bun)

## Development

### Local Development

```bash
git clone https://github.com/MAHMETT/better-laravel-react-installer.git
cd better-laravel-react-installer
./better-laravel new
```

### Configuration

Edit files in `configs/`:

- `project.conf` — Branches, runtimes, cleanup rules
- `ui.conf` — Colors and formatting
- `dependencies.conf` — Required dependencies
- `workflow.conf` — Installation steps

## License

MIT License
