# Better Laravel React Installer

A minimal, modern, and robust CLI installer for the Better Laravel React starter kit.

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

### Update Installer

```bash
better-laravel update
```

### Help

```bash
better-laravel --help
```

## Workflow

The installer follows three stages:

### 1. Dependency Checking

Before any user input, the installer verifies required dependencies:

- **PHP** (required)
- **Composer** (required)
- **Node Runtime** (at least one: npm, pnpm, yarn, or bun)

If any dependency is missing, the installer stops immediately with a clear error message.

### 2. User Configuration

After dependencies are verified, you'll be prompted for:

| Field | Description | Default |
|-------|-------------|---------|
| **Project Name** | Lowercase, no spaces, a-z/0-9/-/_ | - |
| **Branch** | Git branch to checkout | `main` |
| **Runtime** | Node package manager | `npm` |
| **Install Packages** | Composer, Node, both, or none | Both |

### 3. Main Installation

The installer performs these steps:

1. Clone the repository
2. Checkout the selected branch
3. Clean up unnecessary files (docs, AI configs, .git)
4. Create `.env` from `.env.example`
5. Install selected dependencies

Result: A ready-to-develop Laravel + React project.

## Requirements

- PHP 8.1+
- Composer
- Git
- Node.js + package manager (npm/pnpm/yarn/bun)

## Project Name Validation

| Rule | Description |
|------|-------------|
| Max length | 200 characters |
| Case | Must be lowercase |
| Spaces | Not allowed |
| Allowed characters | a-z, 0-9, hyphen (-), underscore (_) |

## Branch Options

| Title | Branch Name |
|-------|-------------|
| main | `main` |
| development | `development` |
| + visitor management | `analytics-visitors` |

## Runtime Options

| Runtime | Install Command |
|---------|-----------------|
| npm | `npm install` |
| pnpm | `pnpm install` |
| yarn | `yarn install` |
| bun | `bun install` |

## Installation Options

| Option | Description |
|--------|-------------|
| Both | Install Composer + Node dependencies (default) |
| Composer only | Install only Composer dependencies |
| Node only | Install only Node dependencies |
| None | Skip dependency installation |

## Cleanup

The installer removes these files/folders:

**Folders:** `docs/`, `.agents/`, `.claude/`, `.codex/`, `.qwen/`, `.git/`, `.github/`

**Files:** `.bunrc`, `bun.lock`, `mcp.json`, `AGENTS.md`, `CLAUDE.md`, `QWEN.md`, `boost.json`, `_ide_helper.php`, `opencode.json`

## Examples

```bash
# Start interactive installation
better-laravel new

# Update the installer to the latest version
better-laravel update

# Show help
better-laravel --help
```

## License

MIT
