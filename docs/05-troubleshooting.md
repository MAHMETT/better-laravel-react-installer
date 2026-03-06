# Troubleshooting

Common issues and solutions for the Better Laravel React Installer.

## Installation Issues

### Command Not Found

**Problem:** `better-laravel: command not found`

**Solution:**

1. Verify installation:
   ```bash
   ls -la /usr/local/bin/better-laravel
   ```

2. Ensure `/usr/local/bin` is in PATH:
   ```bash
   echo $PATH
   ```

3. Add to shell config if missing:
   ```bash
   export PATH="/usr/local/bin:$PATH"
   ```

### Permission Denied

**Problem:** `Permission denied` when running installer

**Solution:**

```bash
chmod +x better-laravel installer.sh
```

Or for global install:

```bash
sudo chmod +x /usr/local/bin/better-laravel
```

## Dependency Issues

### PHP Not Found

**Problem:** `Missing dependency: php`

**Solution:**

```bash
# Ubuntu/Debian
sudo apt install php php-cli php-mbstring php-xml php-zip

# macOS (Homebrew)
brew install php

# Verify
php -v
```

### Composer Not Found

**Problem:** `Missing dependency: composer`

**Solution:**

```bash
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Verify
composer --version
```

### Git Not Found

**Problem:** `Missing dependency: git`

**Solution:**

```bash
# Ubuntu/Debian
sudo apt install git

# macOS
brew install git

# Verify
git --version
```

### No Node Runtime Found

**Problem:** `Missing dependency: npm OR pnpm OR yarn OR bun`

**Solution:**

Install at least one Node runtime:

```bash
# npm (comes with Node.js)
# Install Node.js first:
curl -fsSL https://nodejs.org/setup | sudo bash -
sudo apt install nodejs

# pnpm
curl -fsSL https://get.pnpm.io/install.sh | sudo bash -

# yarn
npm install -g yarn

# bun
curl -fsSL https://bun.sh/install | bash
```

## Runtime Issues

### Selected Runtime Not Available

**Problem:** Runtime shows as "not found" during selection

**Solution:**

1. Install the runtime:
   ```bash
   # For pnpm
   curl -fsSL https://get.pnpm.io/install.sh | bash -

   # For yarn
   npm install -g yarn

   # For bun
   curl -fsSL https://bun.sh/install | bash
   ```

2. Or select a different runtime that is installed

### Network Timeout During Clone

**Problem:** `Failed to clone repository`

**Solution:**

1. Check internet connection
2. Verify GitHub accessibility:
   ```bash
   ping github.com
   ```
3. Try again with verbose output:
   ```bash
   git clone https://github.com/MAHMETT/better-laravel-react.git
   ```

## Installation Failures

### Composer Install Fails

**Problem:** `Failed to install Composer dependencies`

**Solution:**

1. Check PHP version:
   ```bash
   php -v
   ```

2. Verify PHP extensions:
   ```bash
   php -m
   ```

3. Check Composer configuration:
   ```bash
   composer diagnose
   ```

4. Manual install for details:
   ```bash
   cd your-project
   composer install
   ```

### Node Install Fails

**Problem:** `Failed to install Node dependencies`

**Solution:**

1. Clear cache:
   ```bash
   npm cache clean --force
   # or
   pnpm store prune
   # or
   yarn cache clean
   ```

2. Check Node version:
   ```bash
   node -v
   ```

3. Manual install for details:
   ```bash
   cd your-project
   npm install
   ```

### Branch Checkout Fails

**Problem:** `Failed to checkout branch`

**Solution:**

1. Verify branch exists:
   ```bash
   git branch -a
   ```

2. Fetch latest branches:
   ```bash
   git fetch --all
   ```

3. Try manual checkout:
   ```bash
   cd your-project
   git checkout branch-name
   ```

## TUI Display Issues

### Broken Characters Display

**Problem:** Shows `` or garbled characters

**Solution:**

1. Ensure terminal supports UTF-8:
   ```bash
   echo $LANG
   ```

2. Set locale if needed:
   ```bash
   export LANG=en_US.UTF-8
   export LC_ALL=en_US.UTF-8
   ```

3. Try a different terminal emulator

### Colors Not Displaying

**Problem:** ANSI colors not showing correctly

**Solution:**

1. Check terminal color support:
   ```bash
   echo -e "\033[31mRed\033[0m"
   ```

2. Set COLORTERM if needed:
   ```bash
   export COLORTERM=truecolor
   ```

## Getting Help

If issues persist:

1. Check the [documentation](./README.md)
2. Review GitHub issues
3. Open a new issue with:
   - Error message
   - OS and shell version
   - PHP/Composer/Node versions
   - Steps to reproduce
