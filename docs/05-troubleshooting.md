# Troubleshooting

## Common Issues

### Missing Dependencies

**Error**: `Missing dependency detected: composer`

**Solution**: Install the missing dependency:
```bash
# Install Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
```

### Permission Denied

**Error**: `Permission denied`

**Solution**: Make the script executable:
```bash
chmod +x install.sh
```

### Git Clone Fails

**Error**: `Failed to clone repository`

**Solutions**:
1. Check your internet connection
2. Verify Git is installed: `git --version`
3. Check GitHub accessibility

### Node Runtime Not Found

**Error**: `Selected runtime not available`

**Solution**: Install the selected runtime or choose another:
```bash
# Install npm (comes with Node.js)
# Install pnpm
curl -fsSL https://get.pnpm.io/install.sh | sh -

# Install yarn
npm install -g yarn

# Install bun
curl -fsSL https://bun.sh/install | bash
```

## Getting Help

If you encounter issues not listed here:
1. Check the error message carefully
2. Verify all prerequisites are installed
3. Ensure you have a stable internet connection
