# Configuration

All installer configuration is centralized in the `configs/` directory.

## Configuration Files

| File | Description |
|------|-------------|
| `project.conf` | Project settings, branches, runtimes |
| `ui.conf` | UI colors, icons, formatting |
| `dependencies.conf` | Required dependencies and checks |
| `workflow.conf` | Installation steps and commands |

## Branch Configuration

Edit `configs/project.conf` to modify branches:

```bash
declare -a BRANCHES
BRANCHES=(
    "main|main"
    "+ visitor management|visitor-management"
)
```

## Runtime Configuration

Available runtimes in `configs/project.conf`:

```bash
declare -a RUNTIMES
RUNTIMES=("npm" "pnpm" "yarn" "bun")
```

## Cleanup Files

Files and folders to remove are defined in `configs/project.conf`:

```bash
CLEANUP_FOLDERS=("docs" ".agents" ".claude" ...)
CLEANUP_FILES=(".bunrc" "bun.lock" "mcp.json" ...)
```

## UI Customization

Modify colors and icons in `configs/ui.conf`:

```bash
COLOR_GREEN='\033[0;32m'
ICON_SUCCESS="✓"
```
