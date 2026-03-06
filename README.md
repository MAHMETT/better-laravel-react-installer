# Better Laravel React Installer

A modern, interactive CLI installer for the Better Laravel React starter kit.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Shell](https://img.shields.io/badge/shell-bash-blue.svg)
![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macos-lightgrey)

## Features

- **Interactive TUI** — Clean, modern terminal interface with proper colors
- **CLI Commands** — Full command-line argument support for automation
- **Dependency Checking** — Automatic verification of required tools
- **Branch Selection** — Choose from predefined project branches
- **Runtime Selection** — Support for npm, pnpm, yarn, or bun
- **Fail-Safe** — Immediate stop on errors with clear messages
- **Cross-Platform** — Works on Linux and macOS

## Quick Start

### Universal Install (Bash/Zsh)

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/scripts/install.sh | bash
```

### Fish Shell

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/scripts/install.fish | fish
```

### Zsh

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/scripts/install.zsh | zsh
```

### Manual Install

```bash
git clone https://github.com/MAHMETT/better-laravel-react-installer.git
cd better-laravel-react-installer
chmod +x better-laravel
sudo mv better-laravel /usr/local/bin/
```

## Usage

### Interactive Installation

```bash
better-laravel new
```

### CLI Mode

```bash
# Use specific runtime
better-laravel new --bun

# Skip Node dependencies
better-laravel new --pnpm --install-composer

# Specify branch
better-laravel new --branch main --no-install
```

## Commands

### Runtime Options

| Flag | Description |
|------|-------------|
| `--npm` | Use npm as package manager |
| `--pnpm` | Use pnpm as package manager |
| `--yarn` | Use yarn as package manager |
| `--bun` | Use bun as package manager |

### Install Options

| Flag | Description |
|------|-------------|
| `--install-all` | Install both Composer and Node deps (default) |
| `--install-composer` | Install only Composer dependencies |
| `--install-node` | Install only Node dependencies |
| `--no-install` | Skip dependency installation |

### Other Options

| Flag | Description |
|------|-------------|
| `--branch <name>` | Skip branch selection, use specified branch |
| `--help`, `-h` | Show help message |

## Examples

```bash
# Interactive installation with prompts
better-laravel new

# Use bun runtime
better-laravel new --bun

# Use pnpm with Node deps only
better-laravel new --pnpm --install-node

# Specify branch and skip install
better-laravel new --branch main --no-install
```

## Requirements

- **PHP** 8.1+
- **Composer** (latest)
- **Git**
- **Node.js** with at least one package manager:
  - npm
  - pnpm
  - yarn
  - bun

## Installation

### Option 1: Global Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/better-laravel | sudo bash -s - /usr/local/bin/better-laravel
```

### Option 2: Manual Install

```bash
git clone https://github.com/MAHMETT/better-laravel-react-installer.git
cd better-laravel-react-installer
chmod +x better-laravel installer.sh
sudo mv better-laravel /usr/local/bin/
```

### Option 3: Local Use

```bash
git clone https://github.com/MAHMETT/better-laravel-react-installer.git
cd better-laravel-react-installer
./better-laravel new
```

## Workflow

When you run `better-laravel new`, the installer:

1. **Checks Dependencies** — Verifies PHP, Composer, Git, and Node runtime
2. **Project Name** — Prompts for a valid project name
3. **Branch Selection** — Choose from available branches
4. **Runtime Selection** — Select npm, pnpm, yarn, or bun
5. **Package Installation** — Choose which dependencies to install
6. **Clone & Setup** — Clones repo, cleans files, sets up environment
7. **Install Dependencies** — Runs composer and/or npm install
8. **Completion** — Shows next steps

## Project Structure

```
better-laravel-react-installer/
├── better-laravel        # CLI wrapper script
├── installer.sh          # Core installer library
├── configs/              # Configuration files
│   ├── project.conf
│   ├── ui.conf
│   ├── dependencies.conf
│   └── workflow.conf
├── docs/                 # Documentation
└── README.md
```

## Development

### Running Locally

```bash
./better-laravel new
```

### Modifying Configuration

Edit files in `configs/`:

- `project.conf` — Branches, runtimes, cleanup rules
- `ui.conf` — Colors, icons, formatting
- `dependencies.conf` — Required dependencies
- `workflow.conf` — Installation steps

## Troubleshooting

### Permission Denied

```bash
chmod +x better-laravel installer.sh
```

### Command Not Found

Ensure `/usr/local/bin` is in your PATH:

```bash
export PATH="/usr/local/bin:$PATH"
```

### Missing Dependencies

Install required tools:

```bash
# PHP (Ubuntu/Debian)
sudo apt install php php-cli php-mbstring php-xml php-zip

# Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Node.js
curl -fsSL https://nodejs.org/setup | sudo bash -
sudo apt install nodejs
```

## License

MIT License — See [LICENSE](LICENSE) for details.

## Support

For issues or questions:

1. Check the [documentation](docs/)
2. Review [troubleshooting guide](docs/05-troubleshooting.md)
3. Open an issue on GitHub
