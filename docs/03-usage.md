# Usage

Learn how to use the Better Laravel React Installer.

## Basic Usage

### Interactive Mode

Run the installer with interactive prompts:

```bash
better-laravel new
```

You will be prompted for:

1. **Project Name** — Name for your project directory
2. **Branch** — Select from available branches
3. **Runtime** — Choose npm, pnpm, yarn, or bun
4. **Dependencies** — Select what to install

### CLI Mode

Use flags to skip prompts:

```bash
# Specify runtime
better-laravel new --bun

# Specify runtime and install mode
better-laravel new --pnpm --install-node

# Specify branch and skip install
better-laravel new --branch main --no-install
```

## Command Reference

### Runtime Flags

| Flag | Description |
|------|-------------|
| `--npm` | Use npm (default if not specified) |
| `--pnpm` | Use pnpm |
| `--yarn` | Use yarn |
| `--bun` | Use bun |

### Install Flags

| Flag | Description |
|------|-------------|
| `--install-all` | Install both Composer and Node (default) |
| `--install-composer` | Install only Composer dependencies |
| `--install-node` | Install only Node dependencies |
| `--no-install` | Skip dependency installation |

### Other Flags

| Flag | Description |
|------|-------------|
| `--branch <name>` | Use specified branch without prompting |
| `--help`, `-h` | Show help message |

## Examples

### Example 1: Default Interactive Install

```bash
better-laravel new
```

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Better Laravel React Installer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

─── Checking Dependencies ─────────────────────────────────

  ✔ PHP: PHP 8.2.0 (cli) ...
  ✔ Composer: Composer version 2.6.0
  ✔ Git: git version 2.40.0
  ✔ Node Runtime: npm: 9.6.7

─── Project Configuration ─────────────────────────────────

  ▶ Enter project name: my-project
  ✔ Project name: my-project

─── Branch Selection ──────────────────────────────────────

  Available branches

  1) main (default)
  2) + visitor management

  ▶ Select branch [1-2]:
```

### Example 2: Quick Install with Bun

```bash
better-laravel new --bun
```

This skips runtime selection and uses bun automatically.

### Example 3: Composer Only Install

```bash
better-laravel new --pnpm --install-composer
```

Installs only Composer dependencies, skips Node packages.

### Example 4: Non-Interactive Setup

```bash
better-laravel new --branch main --bun --no-install
```

Creates project without any dependency installation.

## Workflow

### Step-by-Step Process

| Step | Action | Description |
|------|--------|-------------|
| 1 | Check Dependencies | Verify PHP, Composer, Git, Node runtime |
| 2 | Project Name | Validate and accept project name |
| 3 | Branch Selection | Choose git branch |
| 4 | Runtime Selection | Choose package manager |
| 5 | Install Options | Select dependencies to install |
| 6 | Clone Repository | Clone from GitHub |
| 7 | Checkout Branch | Switch to selected branch |
| 8 | Cleanup | Remove unnecessary files |
| 9 | Environment Setup | Copy .env, generate key |
| 10 | Install Dependencies | Run composer/npm install |

## Output Format

### Success Messages

```
  ✔ Repository cloned successfully
  ✔ Switched to branch 'main'
  ✔ Generated application key
```

### Error Messages

```
  ✖ Failed to clone repository
  Reason: network timeout
  Installation aborted.
```

### Step Progress

```
[STEP 1/6] Cloning repository...
[STEP 2/6] Entering project directory...
[STEP 3/6] Switching to branch 'main'...
```

## Next Steps

After installation completes:

```bash
cd your-project-name
php artisan serve
```

Open http://localhost:8000 in your browser.

## Related

- [Configuration](./04-configuration.md) — Customize installer behavior
- [Troubleshooting](./05-troubleshooting.md) — Common issues and solutions
