#!/bin/bash

# ==============================================================================
# Better Laravel React Installer - Core Library
# ==============================================================================
# This is the core installer library. Do not execute directly.
# Use the 'better-laravel' wrapper script instead.
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/configs"

# Source all configuration files
source "$CONFIG_DIR/project.conf"
source "$CONFIG_DIR/ui.conf"
source "$CONFIG_DIR/dependencies.conf"
source "$CONFIG_DIR/workflow.conf"

# ==============================================================================
# GLOBAL VARIABLES
# ==============================================================================

PROJECT_NAME=""
SELECTED_BRANCH=""
SELECTED_RUNTIME=""
INSTALL_COMPOSER=$DEFAULT_INSTALL_COMPOSER
INSTALL_NODE=$DEFAULT_INSTALL_NODE

# CLI flags
CLI_MODE=false
CLI_RUNTIME=""
CLI_INSTALL_MODE=""

# ==============================================================================
# COLOR UTILITIES
# ==============================================================================

# Reset
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

# Colors
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
GRAY="\033[90m"
BRIGHT_CYAN="\033[96m"
BRIGHT_WHITE="\033[97m"

# Background
BG_BLUE="\033[44m"

# ==============================================================================
# TUI OUTPUT FUNCTIONS
# ==============================================================================

print_banner() {
    local width=40
    local line=""
    
    # Build separator line
    for ((i=0; i<width; i++)); do
        line="${line}━"
    done
    
    echo ""
    echo -e "${BRIGHT_CYAN}${line}${RESET}"
    echo -e "${BOLD}${BRIGHT_CYAN}   Better Laravel React Installer${RESET}"
    echo -e "${BRIGHT_CYAN}${line}${RESET}"
    echo -e "${DIM}   Interactive Laravel Starter Kit${RESET}"
    echo ""
}

print_section() {
    local title="$1"
    local width=40
    local line=""
    
    for ((i=0; i<width; i++)); do
        line="${line}─"
    done
    
    echo ""
    echo -e "${DIM}${line}${RESET}"
    echo -e "${BOLD}${WHITE} ${title}${RESET}"
    echo -e "${DIM}${line}${RESET}"
}

print_step() {
    local step_num="$1"
    local total_steps="$2"
    local message="$3"
    
    echo -e "${GREEN}[STEP ${step_num}/${total_steps}]${RESET} ${message}"
}

print_success() {
    echo -e "  ${GREEN}✔${RESET} $1"
}

print_error() {
    echo -e "  ${RED}✖${RESET} ${RED}$1${RESET}"
}

print_warning() {
    echo -e "  ${YELLOW}⚠${RESET} $1"
}

print_info() {
    echo -e "  ${CYAN}ℹ${RESET} $1"
}

print_prompt() {
    echo -e "  ${BLUE}▶${RESET} "
}

# ==============================================================================
# ERROR HANDLING
# ==============================================================================

# Track installation state
INSTALLATION_STARTED="false"
INSTALLATION_COMPLETED="false"

handle_error() {
    local message="$1"
    local reason="$2"

    echo ""
    print_error "$message"

    if [ -n "$reason" ]; then
        echo -e "  ${DIM}Reason: $reason${RESET}"
    fi

    echo -e "\n${RED}Installation aborted.${RESET}"
    echo ""
    exit 1
}

cleanup_on_error() {
    local exit_code=$?
    if [ $exit_code -ne 0 ] && [ "$INSTALLATION_COMPLETED" != "true" ]; then
        echo ""
        print_error "Installation failed with exit code $exit_code"
        print_warning "Please check the error message above and try again."
        echo ""
    fi
}

# Handle interrupt signals (Ctrl+C, Ctrl+Z)
handle_interrupt() {
    local signal="$1"
    local signal_name=""
    
    case "$signal" in
        INT)
            signal_name="Ctrl+C"
            ;;
        TSTP)
            signal_name="Ctrl+Z"
            ;;
        TERM)
            signal_name="SIGTERM"
            ;;
        *)
            signal_name="signal"
            ;;
    esac
    
    echo ""
    echo ""
    print_section "Installation Cancelled"
    echo ""
    
    if [ "$INSTALLATION_STARTED" = "true" ] && [ "$INSTALLATION_COMPLETED" != "true" ]; then
        echo -e "  ${YELLOW}⚠${RESET} ${YELLOW}Installation interrupted by user ($signal_name)${RESET}"
        echo ""
        
        # Check if project directory was created
        if [ -n "$PROJECT_NAME" ] && [ -d "$PROJECT_NAME" ]; then
            echo -e "  ${DIM}Partial installation detected:${RESET}"
            echo -e "  ${DIM}Project directory '$PROJECT_NAME' was created${RESET}"
            echo ""
            echo -e "  ${CYAN}Options:${RESET}"
            echo ""
            echo -e "  1) ${DIM}Continue manually:${RESET}"
            echo -e "     ${GRAY}cd $PROJECT_NAME${RESET}"
            echo -e "     ${GRAY}# Complete remaining setup steps${RESET}"
            echo ""
            echo -e "  2) ${DIM}Remove and restart:${RESET}"
            echo -e "     ${GRAY}rm -rf $PROJECT_NAME${RESET}"
            echo -e "     ${GRAY}better-laravel new${RESET}"
            echo ""
            echo -e "  3) ${DIM}Remove partial installation:${RESET}"
            echo -e "     ${GRAY}rm -rf $PROJECT_NAME${RESET}"
            echo ""
        else
            echo -e "  ${DIM}No changes were made to your system${RESET}"
            echo ""
        fi
        
        echo -e "  ${RED}Installation cancelled.${RESET}"
    else
        echo -e "  ${DIM}Installation was cancelled before any changes were made${RESET}"
        echo ""
    fi
    
    echo ""
    echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${DIM}   Thank you for using Better Laravel React Installer${RESET}"
    echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    
    # Clean up any temporary files
    cleanup_temporary_files
    
    exit 130
}

# Cleanup temporary files
cleanup_temporary_files() {
    # Remove any temporary files created during installation
    if [ -n "$TEMP_DOWNLOAD_DIR" ] && [ -d "$TEMP_DOWNLOAD_DIR" ]; then
        rm -rf "$TEMP_DOWNLOAD_DIR" 2>/dev/null
    fi
}

# Set up signal traps
setup_signal_traps() {
    trap 'handle_interrupt INT' INT
    trap 'handle_interrupt TSTP' TSTP
    trap 'handle_interrupt TERM' TERM
    trap cleanup_on_error EXIT
}

# ==============================================================================
# DEPENDENCY CHECKING
# ==============================================================================

check_dependencies() {
    print_section "Checking Dependencies"
    
    local has_error=false
    local missing_deps=()
    
    # Check PHP
    if ! command -v php &> /dev/null; then
        missing_deps+=("php")
    else
        local php_version=$(php -v 2>&1 | head -n 1)
        print_success "PHP: ${DIM}${php_version}${RESET}"
    fi
    
    # Check Composer
    if ! command -v composer &> /dev/null; then
        missing_deps+=("composer")
    else
        local composer_version=$(composer --version 2>&1)
        print_success "Composer: ${DIM}${composer_version}${RESET}"
    fi
    
    # Check Git
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    else
        local git_version=$(git --version 2>&1)
        print_success "Git: ${DIM}${git_version}${RESET}"
    fi
    
    # Check Node runtime (at least one required)
    local runtime_found=false
    local found_runtimes=()
    
    for runtime in "${NODE_RUNTIMES[@]}"; do
        if command -v "$runtime" &> /dev/null; then
            runtime_found=true
            local version=$("$runtime" --version 2>&1 | head -n 1)
            found_runtimes+=("$runtime: ${DIM}${version}${RESET}")
        fi
    done
    
    if [ "$runtime_found" = true ]; then
        echo -e "  ${GREEN}✔${RESET} Node Runtime: ${found_runtimes[*]}"
    else
        missing_deps+=("npm OR pnpm OR yarn OR bun")
    fi
    
    echo ""
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${RED}Missing dependencies:${RESET}"
        for dep in "${missing_deps[@]}"; do
            echo -e "  ${RED}•${RESET} $dep"
        done
        echo ""
        echo -e "${RED}Installation cannot continue.${RESET}"
        echo ""
        exit 1
    fi
    
    print_success "All dependencies satisfied!"
}

# ==============================================================================
# INPUT VALIDATION
# ==============================================================================

validate_project_name() {
    local name="$1"
    
    if [ -z "$name" ]; then
        return 1
    fi
    
    if [ ${#name} -gt $PROJECT_NAME_MAX_LENGTH ]; then
        return 1
    fi
    
    if [ "$name" != "${name,,}" ]; then
        return 1
    fi
    
    if [[ "$name" =~ [[:space:]] ]]; then
        return 1
    fi
    
    if ! [[ "$name" =~ $PROJECT_NAME_PATTERN ]]; then
        return 1
    fi
    
    return 0
}

# ==============================================================================
# USER INPUT - INTERACTIVE MODE
# ==============================================================================

get_project_name() {
    print_section "Project Configuration"
    
    while true; do
        echo ""
        echo -ne "  ${CYAN}Enter project name${RESET}: "
        read -r PROJECT_NAME
        
        if validate_project_name "$PROJECT_NAME"; then
            print_success "Project name: ${BOLD}$PROJECT_NAME${RESET}"
            break
        else
            echo ""
            print_error "Invalid project name"
            echo ""
            echo -e "  ${DIM}Requirements:${RESET}"
            echo -e "  • Maximum $PROJECT_NAME_MAX_LENGTH characters"
            echo -e "  • Must be lowercase"
            echo -e "  • No spaces (use '-' instead)"
            echo -e "  • Allowed: a-z, 0-9, hyphen (-), underscore (_)"
            echo ""
        fi
    done
}

get_branch() {
    echo ""
    print_section "Branch Selection"
    echo ""
    echo -e "  ${DIM}Available branches:${RESET}"
    echo ""
    
    local branch_count=${#BRANCHES[@]}
    
    for i in "${!BRANCHES[@]}"; do
        IFS='|' read -r title branch_name <<< "${BRANCHES[$i]}"
        local is_default=""
        
        if [ $i -eq $((DEFAULT_BRANCH_INDEX - 1)) ]; then
            is_default="${DIM} (default)${RESET}"
        fi
        
        echo -e "  ${GREEN}$((i + 1))${RESET}) $title$is_default"
    done
    
    echo ""
    
    while true; do
        echo -ne "  ${CYAN}Select branch${RESET} [1-$branch_count]: "
        read -r branch_choice
        
        if [ -z "$branch_choice" ]; then
            branch_choice=1
        fi
        
        if [[ "$branch_choice" =~ ^[0-9]+$ ]] && \
           [ "$branch_choice" -ge 1 ] && \
           [ "$branch_choice" -le "$branch_count" ]; then
            IFS='|' read -r title branch_name <<< "${BRANCHES[$((branch_choice - 1))]}"
            SELECTED_BRANCH="$branch_name"
            print_success "Branch: ${BOLD}$SELECTED_BRANCH${RESET}"
            break
        else
            print_error "Invalid selection. Choose 1-$branch_count."
        fi
    done
}

get_runtime() {
    echo ""
    print_section "Runtime Selection"
    echo ""
    echo -e "  ${DIM}Available runtimes:${RESET}"
    echo ""
    
    local max_len=0
    for runtime in "${RUNTIMES[@]}"; do
        if [ ${#runtime} -gt $max_len ]; then
            max_len=${#runtime}
        fi
    done
    
    for i in "${!RUNTIMES[@]}"; do
        runtime="${RUNTIMES[$i]}"
        local status=""
        local is_default=""
        
        if command -v "$runtime" &> /dev/null; then
            status="${GREEN}available${RESET}"
        else
            status="${RED}not found${RESET}"
        fi
        
        if [ "$runtime" = "$DEFAULT_RUNTIME" ]; then
            is_default="${DIM} (default)${RESET}"
        fi
        
        printf "  ${GREEN}%d${RESET}) %-${max_len}s  %s%s\n" $((i + 1)) "$runtime" "$status" "$is_default"
    done
    
    echo ""
    
    while true; do
        echo -ne "  ${CYAN}Select runtime${RESET} [1-${#RUNTIMES[@]}]: "
        read -r runtime_choice
        
        if [ -z "$runtime_choice" ]; then
            runtime_choice=1
        fi
        
        if [[ "$runtime_choice" =~ ^[0-9]+$ ]] && \
           [ "$runtime_choice" -ge 1 ] && \
           [ "$runtime_choice" -le "${#RUNTIMES[@]}" ]; then
            SELECTED_RUNTIME="${RUNTIMES[$((runtime_choice - 1))]}"
            
            if command -v "$SELECTED_RUNTIME" &> /dev/null; then
                print_success "Runtime: ${BOLD}$SELECTED_RUNTIME${RESET}"
                break
            else
                print_error "$SELECTED_RUNTIME is not available"
                echo -e "  ${DIM}Please install it or choose a different runtime${RESET}"
            fi
        else
            print_error "Invalid selection. Choose 1-${#RUNTIMES[@]}."
        fi
    done
}

get_auto_install() {
    echo ""
    print_section "Package Installation"
    echo ""
    echo -e "  ${DIM}Select packages to install:${RESET}"
    echo ""
    echo -e "  ${GREEN}1${RESET}) Both Composer and Node dependencies  ${DIM}(default)${RESET}"
    echo -e "  ${GREEN}2${RESET}) Only Composer dependencies"
    echo -e "  ${GREEN}3${RESET}) Only Node dependencies"
    echo -e "  ${GREEN}4${RESET}) None (manual installation)"
    echo ""
    
    while true; do
        echo -ne "  ${CYAN}Select option${RESET} [1-4]: "
        read -r install_choice
        
        if [ -z "$install_choice" ]; then
            install_choice=1
        fi
        
        if [[ "$install_choice" =~ ^[0-9]+$ ]] && \
           [ "$install_choice" -ge 1 ] && \
           [ "$install_choice" -le 4 ]; then
            case $install_choice in
                1)
                    INSTALL_COMPOSER=true
                    INSTALL_NODE=true
                    print_success "Installing: ${BOLD}Composer + Node${RESET}"
                    ;;
                2)
                    INSTALL_COMPOSER=true
                    INSTALL_NODE=false
                    print_success "Installing: ${BOLD}Composer only${RESET}"
                    ;;
                3)
                    INSTALL_COMPOSER=false
                    INSTALL_NODE=true
                    print_success "Installing: ${BOLD}Node only${RESET}"
                    ;;
                4)
                    INSTALL_COMPOSER=false
                    INSTALL_NODE=false
                    print_success "Installing: ${BOLD}None${RESET}"
                    ;;
            esac
            break
        else
            print_error "Invalid selection. Choose 1-4."
        fi
    done
}

confirm_installation() {
    echo ""
    print_section "Installation Summary"
    echo ""
    echo -e "  ${DIM}Project:${RESET}     ${BOLD}$PROJECT_NAME${RESET}"
    echo -e "  ${DIM}Branch:${RESET}      ${BOLD}$SELECTED_BRANCH${RESET}"
    echo -e "  ${DIM}Runtime:${RESET}     ${BOLD}$SELECTED_RUNTIME${RESET}"
    echo -e "  ${DIM}Composer:${RESET}    ${BOLD}$([ "$INSTALL_COMPOSER" = true ] && echo "Yes" || echo "No")${RESET}"
    echo -e "  ${DIM}Node:${RESET}        ${BOLD}$([ "$INSTALL_NODE" = true ] && echo "Yes ($SELECTED_RUNTIME)" || echo "No")${RESET}"
    echo ""
    echo -ne "  ${BLUE}▶${RESET} Proceed with installation? [y/N]: "
    read -r confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        print_success "Starting installation..."
    else
        echo ""
        print_warning "Installation cancelled by user."
        echo ""
        exit 0
    fi
}

# ==============================================================================
# INSTALLATION PROCESS
# ==============================================================================

INSTALLATION_STARTED="true"

clone_repository() {
    print_step "1" "6" "Cloning repository..."
    
    if git clone "$REPO_URL" "$PROJECT_NAME" > /dev/null 2>&1; then
        print_success "Repository cloned to '${BOLD}$PROJECT_NAME${RESET}'"
    else
        handle_error "Failed to clone repository" "Network error or repository not accessible"
    fi
}

enter_project_directory() {
    print_step "2" "6" "Entering project directory..."
    
    if cd "$PROJECT_NAME" 2>/dev/null; then
        print_success "Changed to project directory"
    else
        handle_error "Failed to enter project directory" "Directory '$PROJECT_NAME' not found"
    fi
}

checkout_branch() {
    print_step "3" "6" "Switching to branch '$SELECTED_BRANCH'..."
    
    if git checkout "$SELECTED_BRANCH" > /dev/null 2>&1; then
        print_success "Switched to branch '${BOLD}$SELECTED_BRANCH${RESET}'"
    else
        handle_error "Failed to checkout branch '$SELECTED_BRANCH'" "Branch may not exist"
    fi
}

cleanup_files() {
    print_step "4" "6" "Cleaning project files..."
    
    local removed_count=0
    
    for folder in "${CLEANUP_FOLDERS[@]}"; do
        if [ -d "$folder" ]; then
            rm -rf "$folder"
            ((removed_count++))
        fi
    done
    
    for file in "${CLEANUP_FILES[@]}"; do
        if [ -f "$file" ]; then
            rm -f "$file"
            ((removed_count++))
        fi
    done
    
    print_success "Removed ${BOLD}$removed_count${RESET} unnecessary file(s)/folder(s)"
}

setup_environment() {
    print_step "5" "6" "Setting up environment..."
    
    if [ -f "$ENV_SOURCE_FILE" ]; then
        cp "$ENV_SOURCE_FILE" "$ENV_TARGET_FILE"
        print_success "Created .env file"
    else
        print_warning "$ENV_SOURCE_FILE not found"
    fi
    
    if [ "$ARTISAN_KEY_GENERATE" = true ]; then
        if php artisan key:generate > /dev/null 2>&1; then
            print_success "Generated application key"
        else
            print_warning "Failed to generate application key"
        fi
    fi
}

install_dependencies() {
    if [ "$INSTALL_COMPOSER" = true ]; then
        print_step "6a" "6" "Installing Composer dependencies..."
        
        if eval "$COMPOSER_INSTALL_CMD" > /dev/null 2>&1; then
            print_success "Composer dependencies installed"
        else
            handle_error "Failed to install Composer dependencies" "Check PHP and Composer configuration"
        fi
    fi
    
    if [ "$INSTALL_NODE" = true ]; then
        print_step "6b" "6" "Installing Node dependencies with $SELECTED_RUNTIME..."
        
        local install_cmd=""
        case $SELECTED_RUNTIME in
            npm)   install_cmd="$NPM_INSTALL_CMD" ;;
            pnpm)  install_cmd="$PNPM_INSTALL_CMD" ;;
            yarn)  install_cmd="$YARN_INSTALL_CMD" ;;
            bun)   install_cmd="$BUN_INSTALL_CMD" ;;
        esac
        
        if eval "$install_cmd" > /dev/null 2>&1; then
            print_success "Node dependencies installed with ${BOLD}$SELECTED_RUNTIME${RESET}"
        else
            handle_error "Failed to install Node dependencies" "Check $SELECTED_RUNTIME configuration"
        fi
    fi
}

# ==============================================================================
# COMPLETION
# ==============================================================================

print_completion() {
    echo ""
    print_section "Installation Complete"
    echo ""
    echo -e "  ${GREEN}✔${RESET} ${GREEN}Installation completed successfully!${RESET}"
    echo ""
    echo -e "  ${DIM}Project:${RESET}  ${BOLD}$PROJECT_NAME${RESET}"
    echo -e "  ${DIM}Branch:${RESET}   ${BOLD}$SELECTED_BRANCH${RESET}"
    echo -e "  ${DIM}Runtime:${RESET}  ${BOLD}$SELECTED_RUNTIME${RESET}"

    local deps_installed=""
    if [ "$INSTALL_COMPOSER" = true ] && [ "$INSTALL_NODE" = true ]; then
        deps_installed="composer, node"
    elif [ "$INSTALL_COMPOSER" = true ]; then
        deps_installed="composer"
    elif [ "$INSTALL_NODE" = true ]; then
        deps_installed="node"
    else
        deps_installed="none"
    fi
    echo -e "  ${DIM}Dependencies:${RESET} ${BOLD}$deps_installed${RESET}"
    echo ""

    if [ "$INSTALL_COMPOSER" = false ] || [ "$INSTALL_NODE" = false ]; then
        echo -e "  ${YELLOW}⚠${RESET} ${YELLOW}Some dependencies were not installed automatically${RESET}"
        echo -e "     ${DIM}Run manually:${RESET}"
        [ "$INSTALL_COMPOSER" = false ] && echo -e "       • composer install"
        [ "$INSTALL_NODE" = false ] && echo -e "       • $SELECTED_RUNTIME install"
        echo ""
    fi

    echo -e "  ${DIM}Next steps:${RESET}"
    echo -e "     ${CYAN}cd $PROJECT_NAME${RESET}"
    echo -e "     ${CYAN}php artisan serve${RESET}"
    echo ""
    echo -e "  ${BRIGHT_CYAN}Happy coding!${RESET}"
    echo ""
    
    # Mark installation as completed
    INSTALLATION_COMPLETED="true"
}

# ==============================================================================
# CLI COMMAND PARSING
# ==============================================================================

parse_cli_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --npm)
                CLI_RUNTIME="npm"
                shift
                ;;
            --pnpm)
                CLI_RUNTIME="pnpm"
                shift
                ;;
            --yarn)
                CLI_RUNTIME="yarn"
                shift
                ;;
            --bun)
                CLI_RUNTIME="bun"
                shift
                ;;
            --install-all)
                CLI_INSTALL_MODE="all"
                shift
                ;;
            --install-composer)
                CLI_INSTALL_MODE="composer"
                shift
                ;;
            --install-node)
                CLI_INSTALL_MODE="node"
                shift
                ;;
            --no-install)
                CLI_INSTALL_MODE="none"
                shift
                ;;
            --branch)
                CLI_BRANCH="$2"
                shift 2
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                echo -e "${RED}Unknown option: $1${RESET}"
                echo -e "${DIM}Run with --help for usage information${RESET}"
                exit 1
                ;;
        esac
    done
}

apply_cli_options() {
    CLI_MODE=true
    
    # Apply runtime
    if [ -n "$CLI_RUNTIME" ]; then
        if command -v "$CLI_RUNTIME" &> /dev/null; then
            SELECTED_RUNTIME="$CLI_RUNTIME"
        else
            echo -e "${RED}Error: $CLI_RUNTIME is not installed${RESET}"
            exit 1
        fi
    else
        SELECTED_RUNTIME="$DEFAULT_RUNTIME"
    fi
    
    # Apply install mode
    case $CLI_INSTALL_MODE in
        all)
            INSTALL_COMPOSER=true
            INSTALL_NODE=true
            ;;
        composer)
            INSTALL_COMPOSER=true
            INSTALL_NODE=false
            ;;
        node)
            INSTALL_COMPOSER=false
            INSTALL_NODE=true
            ;;
        none)
            INSTALL_COMPOSER=false
            INSTALL_NODE=false
            ;;
        *)
            # Default behavior
            ;;
    esac
}

# ==============================================================================
# HELP COMMAND
# ==============================================================================

show_help() {
    echo ""
    echo -e "${BRIGHT_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${BOLD}${BRIGHT_CYAN}   Better Laravel React Installer${RESET}"
    echo -e "${BRIGHT_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo -e "${DIM}A modern installer for Laravel React starter kits${RESET}"
    echo ""
    echo -e "${BOLD}USAGE${RESET}"
    echo -e "  better-laravel new [options]"
    echo ""
    echo -e "${BOLD}RUNTIME OPTIONS${RESET}"
    echo -e "  --npm           Use npm as package manager"
    echo -e "  --pnpm          Use pnpm as package manager"
    echo -e "  --yarn          Use yarn as package manager"
    echo -e "  --bun           Use bun as package manager"
    echo ""
    echo -e "${BOLD}INSTALL OPTIONS${RESET}"
    echo -e "  --install-all        Install both Composer and Node deps (default)"
    echo -e "  --install-composer   Install only Composer dependencies"
    echo -e "  --install-node       Install only Node dependencies"
    echo -e "  --no-install         Skip dependency installation"
    echo ""
    echo -e "${BOLD}OTHER OPTIONS${RESET}"
    echo -e "  --branch <name>  Skip branch selection, use specified branch"
    echo -e "  --help, -h       Show this help message"
    echo ""
    echo -e "${BOLD}EXAMPLES${RESET}"
    echo -e "  ${DIM}# Interactive installation${RESET}"
    echo -e "  better-laravel new"
    echo ""
    echo -e "  ${DIM}# Use bun runtime${RESET}"
    echo -e "  better-laravel new --bun"
    echo ""
    echo -e "  ${DIM}# Use pnpm with Node deps only${RESET}"
    echo -e "  better-laravel new --pnpm --install-node"
    echo ""
    echo -e "  ${DIM}# Specify branch and skip install${RESET}"
    echo -e "  better-laravel new --branch main --no-install"
    echo ""
}

# ==============================================================================
# INTERACTIVE WORKFLOW
# ==============================================================================

run_interactive() {
    get_project_name
    get_branch
    get_runtime
    get_auto_install
    confirm_installation
}

run_cli_mode() {
    # In CLI mode, we still need project name and possibly branch
    print_section "Project Configuration"
    
    while true; do
        echo ""
        echo -ne "  ${CYAN}Enter project name${RESET}: "
        read -r PROJECT_NAME
        
        if validate_project_name "$PROJECT_NAME"; then
            print_success "Project name: ${BOLD}$PROJECT_NAME${RESET}"
            break
        else
            print_error "Invalid project name"
            echo -e "  ${DIM}Requirements: lowercase, no spaces, a-z 0-9 - _${RESET}"
        fi
    done
    
    # Apply branch from CLI or prompt
    if [ -n "$CLI_BRANCH" ]; then
        SELECTED_BRANCH="$CLI_BRANCH"
        print_success "Branch: ${BOLD}$SELECTED_BRANCH${RESET}"
    else
        get_branch
    fi
    
    print_success "Runtime: ${BOLD}$SELECTED_RUNTIME${RESET}"
    
    local install_desc=""
    if [ "$INSTALL_COMPOSER" = true ] && [ "$INSTALL_NODE" = true ]; then
        install_desc="Composer + Node"
    elif [ "$INSTALL_COMPOSER" = true ]; then
        install_desc="Composer only"
    elif [ "$INSTALL_NODE" = true ]; then
        install_desc="Node only"
    else
        install_desc="None"
    fi
    print_success "Installing: ${BOLD}$install_desc${RESET}"
    
    echo ""
    echo -ne "  ${BLUE}▶${RESET} Proceed? [y/N]: "
    read -r confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        print_success "Starting installation..."
    else
        echo ""
        print_warning "Installation cancelled."
        echo ""
        exit 0
    fi
}

# ==============================================================================
# MAIN WORKFLOW
# ==============================================================================

main() {
    local mode="$1"
    shift

    case "$mode" in
        new)
            print_banner

            # Set up signal traps for Ctrl+C, Ctrl+Z handling
            setup_signal_traps

            # Parse CLI arguments
            if [ $# -gt 0 ]; then
                parse_cli_args "$@"
                apply_cli_options
                run_cli_mode
            else
                check_dependencies
                run_interactive
            fi

            echo ""
            print_section "Installing"
            echo ""

            # Mark installation as started
            INSTALLATION_STARTED="true"

            clone_repository
            enter_project_directory
            checkout_branch
            cleanup_files
            setup_environment
            install_dependencies

            # Mark installation as completed
            INSTALLATION_COMPLETED="true"

            print_completion
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            show_help
            ;;
    esac
}
