# Project Structure

Directory layout and file organization.

```
better-laravel-react-installer/
├── better-laravel            # CLI wrapper script (executable)
├── installer.sh              # Core installer library
├── README.md                 # Project documentation
├── configs/                  # Configuration files
│   ├── README.md             # Configuration documentation
│   ├── project.conf          # Project settings, branches, runtimes
│   ├── ui.conf               # UI colors, icons, formatting
│   ├── dependencies.conf     # Required dependencies
│   └── workflow.conf         # Installation workflow steps
├── docs/                     # Documentation
│   ├── README.md             # Documentation index
│   ├── 01-overview.md        # Project overview
│   ├── 02-installation.md    # Installation guide
│   ├── 03-usage.md           # Usage instructions
│   ├── 04-configuration.md   # Configuration options
│   ├── 05-troubleshooting.md # Troubleshooting guide
│   └── 06-structure.md       # This file
└── .qwen/                    # Qwen Code configuration
    ├── mcp/                  # MCP server configs
    ├── skills/               # Custom skills
    ├── settings.json         # Qwen Code settings
    └── output-language.md    # Language preferences
```

## Core Files

### `better-laravel`

The main CLI wrapper that provides the command interface.

- Handles command parsing
- Sources the installer library
- Executes the main workflow

### `installer.sh`

The core installer library containing all logic.

- TUI functions
- Dependency checking
- User input handling
- Installation workflow
- CLI argument parsing

## Configuration Directory

### `configs/project.conf`

Project-specific settings:

- Repository URL
- Branch definitions
- Runtime options
- Cleanup rules
- Validation patterns

### `configs/ui.conf`

User interface configuration:

- Color definitions
- Icon/symbol definitions
- Output formatting

### `configs/dependencies.conf`

Dependency management:

- Required commands list
- Node runtime options
- Error messages

### `configs/workflow.conf`

Installation workflow:

- Step definitions
- Environment setup config
- Install commands

## Documentation Directory

| File | Purpose |
|------|---------|
| `README.md` | Documentation index |
| `01-overview.md` | Features and requirements |
| `02-installation.md` | Installation instructions |
| `03-usage.md` | Usage guide and examples |
| `04-configuration.md` | Configuration options |
| `05-troubleshooting.md` | Common issues |
| `06-structure.md` | Project structure |

## Qwen Code Directory

### `.qwen/mcp/`

MCP (Model Context Protocol) server configurations for AI assistance.

### `.qwen/skills/`

Custom skills for specialized tasks.

### `.qwen/settings.json`

Qwen Code IDE settings.

### `.qwen/output-language.md`

Output language preferences.

## File Relationships

```
better-laravel
    └── sources: installer.sh
            └── sources: configs/*.conf

docs/
    └── references: configs/*.conf
```

## Adding New Files

### New Configuration

1. Create `configs/new-feature.conf`
2. Add variables
3. Source in `installer.sh`

### New Documentation

1. Create `docs/XX-topic.md` (XX = sequence number)
2. Update `docs/README.md` table of contents

### New Command

1. Add flag parsing in `installer.sh`
2. Add help text in `show_help()`
3. Update `README.md` and `docs/03-usage.md`
