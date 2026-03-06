# Better Laravel React Installer

A minimal, cross-platform CLI installer for the Better Laravel React starter kit.

## Installation

### Bash

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

## Usage

### Interactive Installation

```bash
better-laravel new
```

### CLI Mode

```bash
better-laravel new --bun
better-laravel new --pnpm --install-node
better-laravel new --no-install
```

## Workflow

1. Run `better-laravel new` in your projects directory
2. Enter a project name (e.g., `my-app`)
3. Select a branch
4. Choose a runtime (npm/pnpm/yarn/bun)
5. Select packages to install
6. The installer clones, configures, and sets up your project

Result: `~/Projects/my-app` ready for development.

## CLI Options

### Runtime

| Flag | Description |
|------|-------------|
| `--npm` | Use npm (default) |
| `--pnpm` | Use pnpm |
| `--yarn` | Use yarn |
| `--bun` | Use bun |

### Installation

| Flag | Description |
|------|-------------|
| `--install-all` | Install Composer + Node (default) |
| `--install-composer` | Install Composer only |
| `--install-node` | Install Node only |
| `--no-install` | Skip installation |

### General

| Flag | Description |
|------|-------------|
| `--help`, `-h` | Show help |

## Examples

```bash
# Interactive installation
better-laravel new

# Use bun runtime
better-laravel new --bun

# pnpm with Node deps only
better-laravel new --pnpm --install-node

# Skip dependency installation
better-laravel new --no-install
```

## Requirements

- PHP 8.1+
- Composer
- Git
- Node.js + package manager (npm/pnpm/yarn/bun)

## License

MIT
