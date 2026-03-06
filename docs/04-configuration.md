# Configuration

All installer configuration is centralized in the `configs/` directory.

## Configuration Files

| File | Purpose |
|------|---------|
| `project.conf` | Project settings, branches, runtimes, cleanup rules |
| `ui.conf` | Colors, icons, formatting |
| `dependencies.conf` | Required dependencies and error messages |
| `workflow.conf` | Installation steps and commands |

## Branch Configuration

Edit `configs/project.conf` to modify available branches:

```bash
declare -a BRANCHES
BRANCHES=(
    "main|main"
    "+ visitor management|visitor-management"
    "+ feature name|feature-branch"
)

# Default branch index (1-based)
DEFAULT_BRANCH_INDEX=1
```

Format: `"Display Title|actual-branch-name"`

## Runtime Configuration

Available runtimes in `configs/project.conf`:

```bash
declare -a RUNTIMES
RUNTIMES=("npm" "pnpm" "yarn" "bun")

# Default runtime
DEFAULT_RUNTIME="npm"
```

## Cleanup Rules

Files and folders removed after cloning:

```bash
# Folders to remove
CLEANUP_FOLDERS=(
    "docs"
    ".agents"
    ".claude"
    ".codex"
    ".qwen"
    ".git"
    ".github"
)

# Files to remove
CLEANUP_FILES=(
    ".bunrc"
    "bun.lock"
    "mcp.json"
    "AGENTS.md"
    "CLAUDE.md"
    "QWEN.md"
    "boost.json"
    "_ide_helper.php"
    "opencode.json"
)
```

## UI Customization

Modify colors and icons in `configs/ui.conf`:

```bash
# Colors (ANSI codes)
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"

# Icons
ICON_SUCCESS="✔"
ICON_ERROR="✖"
ICON_WARNING="⚠"
ICON_INFO="ℹ"
```

## Validation Rules

Project name validation in `configs/project.conf`:

```bash
PROJECT_NAME_MAX_LENGTH=200
PROJECT_NAME_PATTERN="^[a-z0-9_-]+$"
```

## Environment Setup

Configure environment file handling in `configs/workflow.conf`:

```bash
ENV_SOURCE_FILE=".env.example"
ENV_TARGET_FILE=".env"
ARTISAN_KEY_GENERATE=true
```

## Install Commands

Dependency installation commands in `configs/workflow.conf`:

```bash
COMPOSER_INSTALL_CMD="composer install --no-interaction"
NPM_INSTALL_CMD="npm install"
PNPM_INSTALL_CMD="pnpm install"
YARN_INSTALL_CMD="yarn install"
BUN_INSTALL_CMD="bun install"
```

## Adding New Configuration

1. Create new `.conf` file in `configs/`
2. Source it in `installer.sh`:
   ```bash
   source "$CONFIG_DIR/your-config.conf"
   ```
3. Use variables throughout the script

## Best Practices

- Keep configuration values separate from logic
- Use descriptive variable names
- Document each configuration option
- Test changes in local mode first
