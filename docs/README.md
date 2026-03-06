# Better Laravel React Installer Documentation

Complete documentation for the Better Laravel React CLI installer.

## Table of Contents

| Document | Description |
|----------|-------------|
| [Overview](./01-overview.md) | Features, requirements, installation methods |
| [Installation](./02-installation.md) | Step-by-step installation guide |
| [Usage](./03-usage.md) | Commands, flags, and examples |
| [Configuration](./04-configuration.md) | Customize installer behavior |
| [Troubleshooting](./05-troubleshooting.md) | Common issues and solutions |
| [Structure](./06-structure.md) | Project directory layout |
| [Shell Installation](./07-shell-installation.md) | Bash, Zsh, Fish installation |
| [Interrupt Handling](./08-interrupt-handling.md) | Ctrl+C, Ctrl+Z behavior |

## Quick Reference

### Install Globally

| Shell | Command |
|-------|---------|
| **Bash** | `curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/refs/heads/main/scripts/install.sh \| bash` |
| **Zsh** | `curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/refs/heads/main/scripts/install.zsh \| zsh` |
| **Fish** | `curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/refs/heads/main/scripts/install.fish \| fish` |

### Run Installer

```bash
# Interactive
better-laravel new

# CLI mode
better-laravel new --bun --install-node
```

### Get Help

```bash
better-laravel --help
```

## Documentation Index

```
docs/
├── README.md                 # This file
├── 01-overview.md           # What is this project?
├── 02-installation.md       # How do I install it?
├── 03-usage.md              # How do I use it?
├── 04-configuration.md      # How do I configure it?
├── 05-troubleshooting.md    # What if something breaks?
└── 06-structure.md          # How is it organized?
```

## Need Help?

1. Check [Troubleshooting](./05-troubleshooting.md) for common issues
2. Review [Usage](./03-usage.md) for command reference
3. Open an issue on GitHub for bugs or feature requests
