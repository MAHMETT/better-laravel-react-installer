# Project Structure

```
better-laravel-react-installer/
├── configs/                    # Configuration files
│   ├── project.conf           # Project settings, branches, runtimes
│   ├── ui.conf                # UI colors, icons, formatting
│   ├── dependencies.conf      # Dependency requirements
│   ├── workflow.conf          # Installation workflow steps
│   └── README.md              # Configuration documentation
├── docs/                       # Documentation
│   ├── README.md              # Documentation index
│   ├── 01-overview.md         # Project overview
│   ├── 02-installation.md     # Installation guide
│   ├── 03-usage.md            # Usage instructions
│   ├── 04-configuration.md    # Configuration options
│   └── 05-troubleshooting.md  # Troubleshooting guide
├── .qwen/                      # Qwen Code configuration
│   ├── mcp/                   # MCP server configs
│   ├── skills/                # Custom skills
│   ├── settings.json          # Qwen Code settings
│   └── output-language.md     # Language preferences
├── install.sh                  # Main installer script
└── README.md                   # Project README
```

## Directories

### `configs/`
Contains all configuration files for the installer. Modify these to customize:
- Available branches
- Runtime options
- UI appearance
- Cleanup rules

### `docs/`
Documentation files in Markdown format.

### `.qwen/`
Qwen Code IDE configuration and extensions.

## Files

### `install.sh`
The main installer script. Sources configurations from `configs/` and executes the installation workflow.

### `README.md`
Project overview and quick start guide.
