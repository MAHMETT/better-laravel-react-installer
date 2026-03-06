# Interrupt Handling

The Better Laravel React Installer provides graceful handling of keyboard interrupts (Ctrl+C, Ctrl+Z).

## Behavior

### During Interactive Prompts

When you press **Ctrl+C** or **Ctrl+Z** during input prompts:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Installation Cancelled
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ℹ Installation was cancelled before any changes were made

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Thank you for using Better Laravel React Installer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### During Installation Steps

When you press **Ctrl+C** or **Ctrl+Z** during installation:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Installation Cancelled
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ⚠ Installation interrupted by user (Ctrl+C)

  Partial installation detected:
  Project directory 'my-project' was created

  Options:

  1) Continue manually:
     cd my-project
     # Complete remaining setup steps

  2) Remove and restart:
     rm -rf my-project
     better-laravel new

  3) Remove partial installation:
     rm -rf my-project

  Installation cancelled.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Thank you for using Better Laravel React Installer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Signal Handling

The installer traps the following signals:

| Signal | Key Combination | Description |
|--------|----------------|-------------|
| `SIGINT` | Ctrl+C | Interrupt signal |
| `SIGTSTP` | Ctrl+Z | Terminal stop signal |
| `SIGTERM` | - | Termination signal |

## Installation States

The installer tracks two states:

### 1. Pre-Installation

Before any changes are made:
- Dependency checking
- User input collection
- Confirmation prompt

**Interrupt behavior:** Clean exit with no changes.

### 2. During Installation

After installation begins:
- Repository cloning
- Branch checkout
- File cleanup
- Environment setup
- Dependency installation

**Interrupt behavior:** Shows partial installation status and recovery options.

### 3. Post-Installation

After successful completion:
- All files installed
- Dependencies installed
- Configuration complete

**Interrupt behavior:** N/A (installation already complete)

## Recovery Options

If installation is interrupted, you have three options:

### Option 1: Continue Manually

If the repository was cloned, you can complete the setup:

```bash
cd my-project
# Run remaining steps manually
composer install
npm install  # or pnpm/yarn/bun install
php artisan key:generate
```

### Option 2: Remove and Restart

Clean up and start fresh:

```bash
rm -rf my-project
better-laravel new
```

### Option 3: Remove Partial Installation

Just clean up without restarting:

```bash
rm -rf my-project
```

## Implementation Details

### Signal Trap Setup

```bash
setup_signal_traps() {
    trap 'handle_interrupt INT' INT
    trap 'handle_interrupt TSTP' TSTP
    trap 'handle_interrupt TERM' TERM
    trap cleanup_on_error EXIT
}
```

### State Tracking

```bash
INSTALLATION_STARTED="false"
INSTALLATION_COMPLETED="false"

# Set to true when installation begins
INSTALLATION_STARTED="true"

# Set to true when installation completes
INSTALLATION_COMPLETED="true"
```

### Cleanup

The interrupt handler performs cleanup:
- Removes temporary download directories
- Displays appropriate messages based on installation state
- Exits with code 130 (standard for Ctrl+C termination)

## Exit Codes

| Code | Description |
|------|-------------|
| `0` | Successful completion |
| `1` | General error |
| `130` | Interrupted by Ctrl+C |

## Best Practices

### For Users

1. **Wait for prompts:** Don't interrupt during file operations
2. **Use Ctrl+C before confirmation:** Cancel before confirming to avoid partial installs
3. **Follow recovery options:** If interrupted, use the suggested recovery steps

### For Developers

1. **Set traps early:** Call `setup_signal_traps` before any operations
2. **Track state:** Use `INSTALLATION_STARTED` and `INSTALLATION_COMPLETED` flags
3. **Clean up:** Always clean temporary files in interrupt handler
4. **Inform users:** Show clear recovery options on interrupt

## Related Documentation

- [Usage Guide](./03-usage.md) - General usage instructions
- [Troubleshooting](./05-troubleshooting.md) - Common issues and solutions
