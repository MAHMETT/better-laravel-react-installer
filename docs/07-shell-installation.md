# Shell Installation Guide

Install the Better Laravel React Installer on any shell environment.

## Supported Shells

| Shell | Script | Auto PATH | Command |
|-------|--------|-----------|---------|
| **Bash** | `install.sh` | ✓ | `curl ... \| bash` |
| **Zsh** | `install.zsh` | ✓ | `curl ... \| zsh` |
| **Fish** | `install.fish` | ✓ | `curl ... \| fish` |
| **Ksh** | `install.sh` | ✓ | `curl ... \| ksh` |
| **Csh/Tcsh** | `install.sh` | Manual | `curl ... \| csh` |

---

## Quick Install Commands

### Bash (Linux/macOS)

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/scripts/install.sh | bash
```

### Zsh (macOS default)

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/scripts/install.zsh | zsh
```

### Fish Shell

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/scripts/install.fish | fish
```

---

## Shell-Specific Instructions

### Bash

**Install:**

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/scripts/install.sh | bash
```

**Config file:** `~/.bashrc`

**Manual PATH setup:**

```bash
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Verify:**

```bash
better-laravel --help
```

---

### Zsh

**Install:**

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/scripts/install.zsh | zsh
```

**Config file:** `~/.zshrc`

**Manual PATH setup:**

```bash
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Verify:**

```bash
better-laravel --help
```

**macOS Note:** Zsh is the default shell on macOS Catalina and later.

---

### Fish Shell

**Install:**

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/scripts/install.fish | fish
```

**Config file:** `~/.config/fish/config.fish`

**Manual PATH setup:**

```fish
fish_add_path /usr/local/bin
```

**Verify:**

```fish
better-laravel --help
```

**Install Fish:**

```bash
# Ubuntu/Debian
sudo apt install fish

# macOS (Homebrew)
brew install fish

# Fedora
sudo dnf install fish
```

---

### Ksh (Korn Shell)

**Install:**

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/scripts/install.sh | ksh
```

**Config file:** `~/.kshrc`

**Manual PATH setup:**

```bash
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.kshrc
```

---

### Csh/Tcsh

**Install:**

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/scripts/install.sh | csh
```

**Config file:** `~/.cshrc`

**Manual PATH setup:**

```csh
echo 'set path = (/usr/local/bin $path)' >> ~/.cshrc
source ~/.cshrc
```

---

## Custom Installation Directory

Install to a custom location:

```bash
curl -fsSL https://raw.githubusercontent.com/MAHMETT/better-laravel-react-installer/main/scripts/install.sh | bash -s -- --install-dir $HOME/.local/bin
```

Then add to PATH:

**Bash/Zsh:**
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

**Fish:**
```fish
echo 'fish_add_path $HOME/.local/bin' >> ~/.config/fish/config.fish
```

---

## Manual Installation

If automatic installation fails:

```bash
# Clone repository
git clone https://github.com/MAHMETT/better-laravel-react-installer.git
cd better-laravel-react-installer

# Make executable
chmod +x better-laravel

# Install globally (requires sudo)
sudo cp better-laravel /usr/local/bin/

# Or install locally
mkdir -p $HOME/.local/bin
cp better-laravel $HOME/.local/bin/
```

---

## Verify Installation

Check that the installer is available:

```bash
better-laravel --help
```

Expected output:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Better Laravel React Installer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

USAGE
  better-laravel new [options]
...
```

---

## Troubleshooting

### Command Not Found

**Problem:** `better-laravel: command not found`

**Solution:**

1. Check if installed:
   ```bash
   ls -la /usr/local/bin/better-laravel
   ```

2. Check PATH:
   ```bash
   echo $PATH
   ```

3. Add to PATH:
   
   **Bash/Zsh:**
   ```bash
   export PATH="/usr/local/bin:$PATH"
   ```
   
   **Fish:**
   ```fish
   fish_add_path /usr/local/bin
   ```

### Permission Denied

**Problem:** `Permission denied` during installation

**Solution:**

Install to user directory:

```bash
curl -fsSL https://.../install.sh | bash -s -- --install-dir $HOME/.local/bin
```

### Curl/Wget Not Available

**Problem:** `curl: command not found` or `wget: command not found`

**Solution:**

Install curl or wget:

```bash
# Ubuntu/Debian
sudo apt install curl

# macOS
brew install curl

# Fedora
sudo dnf install curl
```

Or download manually:

```bash
git clone https://github.com/MAHMETT/better-laravel-react-installer.git
cd better-laravel-react-installer
chmod +x better-laravel
sudo cp better-laravel /usr/local/bin/
```

### Shell Not Detected

**Problem:** Installer doesn't configure PATH correctly

**Solution:**

Manually add to your shell config:

**Bash:** `~/.bashrc`
**Zsh:** `~/.zshrc`
**Fish:** `~/.config/fish/config.fish`

```bash
export PATH="/usr/local/bin:$PATH"
```

Then restart your shell.

---

## Next Steps

After installation:

1. [Usage Guide](../docs/03-usage.md) — Learn how to use the installer
2. Run `better-laravel new` — Start your first project
