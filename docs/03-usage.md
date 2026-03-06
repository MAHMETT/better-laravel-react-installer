# Usage

## Running the Installer

```bash
./install.sh
```

## Installation Workflow

### 1. Banner Display
The script starts with a welcome banner.

### 2. Dependency Check
Automatic verification of:
- PHP
- Composer
- Node runtime (npm/pnpm/yarn/bun)

### 3. User Input
You'll be prompted for:

| Field | Description |
|-------|-------------|
| Project Name | Lowercase, no spaces, max 200 chars |
| Branch | Select from available branches |
| Runtime | Choose npm, pnpm, yarn, or bun |
| Auto Install | Select Composer and/or Node packages |

### 4. Installation Steps
The script performs:
1. Repository cloning
2. Branch checkout
3. Cleanup of unnecessary files
4. Environment setup
5. Dependency installation (optional)

### 5. Completion
Success message with project details.

## Post-Installation

Navigate to your project directory and start development:

```bash
cd project-name
php artisan serve
```
