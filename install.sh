#!/bin/bash

# ==============================================================================
# LOAD CONFIGURATIONS
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

# User selections
PROJECT_NAME=""
SELECTED_BRANCH=""
SELECTED_RUNTIME=""
INSTALL_COMPOSER=$DEFAULT_INSTALL_COMPOSER
INSTALL_NODE=$DEFAULT_INSTALL_NODE

# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================

print_banner() {
    echo ""
    echo -e "${COLOR_CYAN}${BANNER_BORDER_CHAR}$(printf '%*s' "$BANNER_WIDTH" | tr ' ' "${BANNER_BORDER_CHAR}")${COLOR_NC}"
    echo -e "${COLOR_BOLD}${COLOR_CYAN}        ${PROJECT_TITLE}        ${COLOR_NC}"
    echo -e "${COLOR_CYAN}${BANNER_BORDER_CHAR}$(printf '%*s' "$BANNER_WIDTH" | tr ' ' "${BANNER_BORDER_CHAR}")${COLOR_NC}"
    echo -e "${COLOR_GRAY}${PROJECT_SUBTITLE}${COLOR_NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${COLOR_BLUE}$(printf '%*s' "$BANNER_WIDTH" | tr ' ' "${BANNER_SEPARATOR_CHAR}")${COLOR_NC}"
    echo -e "${COLOR_BOLD}${COLOR_BLUE}$1${COLOR_NC}"
    echo -e "${COLOR_BLUE}$(printf '%*s' "$BANNER_WIDTH" | tr ' ' "${BANNER_SEPARATOR_CHAR}")${COLOR_NC}"
}

print_step() {
    printf "${COLOR_GREEN}[STEP $1]${COLOR_NC} $2\n"
}

print_success() {
    echo -e "${COLOR_GREEN}${ICON_SUCCESS}${COLOR_NC} $1"
}

print_error() {
    echo -e "${COLOR_RED}${ICON_ERROR}${COLOR_NC} $1"
}

print_warning() {
    echo -e "${COLOR_YELLOW}${ICON_WARNING}${COLOR_NC} $1"
}

print_info() {
    echo -e "${COLOR_CYAN}${ICON_INFO}${COLOR_NC} $1"
}

# Exit handler for errors
cleanup_on_error() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo ""
        print_error "Installation failed with exit code $exit_code"
        print_warning "Please check the error message above and try again."
        echo ""
    fi
}

trap cleanup_on_error EXIT

# ==============================================================================
# DEPENDENCY CHECKING
# ==============================================================================

check_dependencies() {
    print_section "Checking Dependencies"
    
    local has_error=false
    
    # Check PHP
    if ! command -v php &> /dev/null; then
        print_error "$ERROR_PHP_MISSING"
        has_error=true
    else
        local php_version=$(php -v | head -n 1)
        print_success "PHP found: $php_version"
    fi
    
    # Check Composer
    if ! command -v composer &> /dev/null; then
        print_error "$ERROR_COMPOSER_MISSING"
        has_error=true
    else
        local composer_version=$(composer --version)
        print_success "Composer found: $composer_version"
    fi
    
    # Check Git
    if ! command -v git &> /dev/null; then
        print_error "$ERROR_GIT_MISSING"
        has_error=true
    else
        local git_version=$(git --version)
        print_success "Git found: $git_version"
    fi
    
    # Check Node runtime (at least one required)
    local runtime_found=false
    local found_runtimes=""
    
    for runtime in "${NODE_RUNTIMES[@]}"; do
        if command -v "$runtime" &> /dev/null; then
            runtime_found=true
            local version=$("$runtime" --version 2>&1 | head -n 1)
            found_runtimes="$found_runtimes\n  - $runtime: $version"
        fi
    done
    
    if [ "$runtime_found" = true ]; then
        echo -e "${COLOR_GREEN}${ICON_SUCCESS}${COLOR_NC} Node runtime(s) found:$found_runtimes"
    else
        print_error "$ERROR_NODE_RUNTIME_MISSING"
        has_error=true
    fi
    
    echo ""
    
    if [ "$has_error" = true ]; then
        exit 1
    fi
    
    print_success "All dependencies satisfied!"
}

# ==============================================================================
# INPUT VALIDATION
# ==============================================================================

validate_project_name() {
    local name="$1"
    
    # Check if empty
    if [ -z "$name" ]; then
        return 1
    fi
    
    # Check length
    if [ ${#name} -gt $PROJECT_NAME_MAX_LENGTH ]; then
        return 1
    fi
    
    # Check lowercase
    if [ "$name" != "${name,,}" ]; then
        return 1
    fi
    
    # Check spaces
    if [[ "$name" =~ [[:space:]] ]]; then
        return 1
    fi
    
    # Check allowed characters
    if ! [[ "$name" =~ $PROJECT_NAME_PATTERN ]]; then
        return 1
    fi
    
    return 0
}

# ==============================================================================
# USER INPUT
# ==============================================================================

get_project_name() {
    print_section "Project Configuration"
    
    while true; do
        echo -n "Enter project name${PROMPT_SUFFIX}"
        read -r PROJECT_NAME
        
        if validate_project_name "$PROJECT_NAME"; then
            print_success "Project name: $PROJECT_NAME"
            break
        else
            print_error "Invalid project name!"
            echo "  - Maximum $PROJECT_NAME_MAX_LENGTH characters"
            echo "  - Must be lowercase"
            echo "  - No spaces allowed (use '-' instead)"
            echo "  - Allowed: letters, numbers, hyphen (-), underscore (_)"
            echo ""
        fi
    done
}

get_branch() {
    echo ""
    print_info "Available branches:"
    
    local branch_count=${#BRANCHES[@]}
    
    for i in "${!BRANCHES[@]}"; do
        IFS='|' read -r title branch_name <<< "${BRANCHES[$i]}"
        if [ "$branch_name" = "$DEFAULT_BRANCH_INDEX" ] || [ $i -eq $((DEFAULT_BRANCH_INDEX - 1)) ]; then
            echo "  $((i + 1))) $title ${COLOR_GRAY}(default)${COLOR_NC}"
        else
            echo "  $((i + 1))) $title"
        fi
    done
    
    echo ""
    
    while true; do
        echo -n "Select branch [1-$branch_count] (default: 1): "
        read -r branch_choice
        
        # Default to 1 if empty
        if [ -z "$branch_choice" ]; then
            branch_choice=1
        fi
        
        # Validate choice
        if [[ "$branch_choice" =~ ^[0-9]+$ ]] && \
           [ "$branch_choice" -ge 1 ] && \
           [ "$branch_choice" -le "$branch_count" ]; then
            IFS='|' read -r title branch_name <<< "${BRANCHES[$((branch_choice - 1))]}"
            SELECTED_BRANCH="$branch_name"
            print_success "Branch selected: $SELECTED_BRANCH"
            break
        else
            print_error "Invalid selection. Please choose 1-$branch_count."
        fi
    done
}

get_runtime() {
    echo ""
    print_info "Available runtimes:"
    
    for i in "${!RUNTIMES[@]}"; do
        runtime="${RUNTIMES[$i]}"
        if [ "$runtime" = "$DEFAULT_RUNTIME" ]; then
            if command -v "$runtime" &> /dev/null; then
                echo "  $((i + 1))) $runtime ${COLOR_GREEN}(available, default)${COLOR_NC}"
            else
                echo "  $((i + 1))) $runtime ${COLOR_RED}(not found)${COLOR_NC}"
            fi
        else
            if command -v "$runtime" &> /dev/null; then
                echo "  $((i + 1))) $runtime ${COLOR_GREEN}(available)${COLOR_NC}"
            else
                echo "  $((i + 1))) $runtime ${COLOR_RED}(not found)${COLOR_NC}"
            fi
        fi
    done
    
    echo ""
    
    while true; do
        echo -n "Select runtime [1-${#RUNTIMES[@]}] (default: 1): "
        read -r runtime_choice
        
        # Default to 1 if empty
        if [ -z "$runtime_choice" ]; then
            runtime_choice=1
        fi
        
        # Validate choice
        if [[ "$runtime_choice" =~ ^[0-9]+$ ]] && \
           [ "$runtime_choice" -ge 1 ] && \
           [ "$runtime_choice" -le "${#RUNTIMES[@]}" ]; then
            SELECTED_RUNTIME="${RUNTIMES[$((runtime_choice - 1))]}"
            
            # Verify runtime exists
            if command -v "$SELECTED_RUNTIME" &> /dev/null; then
                print_success "Runtime selected: $SELECTED_RUNTIME"
                break
            else
                print_error "$SELECTED_RUNTIME is not available on your system."
                print_warning "Please choose a different runtime."
            fi
        else
            print_error "Invalid selection. Please choose 1-${#RUNTIMES[@]}."
        fi
    done
}

get_auto_install() {
    echo ""
    print_section "Package Installation"
    echo ""
    echo "Select which packages to install automatically:"
    echo ""
    echo "  1) Both Composer and Node dependencies (default)"
    echo "  2) Only Composer dependencies"
    echo "  3) Only Node dependencies"
    echo "  4) None"
    echo ""
    
    while true; do
        echo -n "Select option [1-4] (default: 1): "
        read -r install_choice
        
        # Default to 1 if empty
        if [ -z "$install_choice" ]; then
            install_choice=1
        fi
        
        # Validate choice
        if [[ "$install_choice" =~ ^[0-9]+$ ]] && \
           [ "$install_choice" -ge 1 ] && \
           [ "$install_choice" -le 4 ]; then
            case $install_choice in
                1)
                    INSTALL_COMPOSER=true
                    INSTALL_NODE=true
                    print_success "Will install: Composer and Node dependencies"
                    ;;
                2)
                    INSTALL_COMPOSER=true
                    INSTALL_NODE=false
                    print_success "Will install: Composer dependencies only"
                    ;;
                3)
                    INSTALL_COMPOSER=false
                    INSTALL_NODE=true
                    print_success "Will install: Node dependencies only"
                    ;;
                4)
                    INSTALL_COMPOSER=false
                    INSTALL_NODE=false
                    print_success "Will install: None (manual installation required)"
                    ;;
            esac
            break
        else
            print_error "Invalid selection. Please choose 1-4."
        fi
    done
}

confirm_installation() {
    echo ""
    print_section "Installation Summary"
    echo ""
    echo "  Project Name:  ${COLOR_BOLD}$PROJECT_NAME${COLOR_NC}"
    echo "  Branch:        ${COLOR_BOLD}$SELECTED_BRANCH${COLOR_NC}"
    echo "  Runtime:       ${COLOR_BOLD}$SELECTED_RUNTIME${COLOR_NC}"
    echo "  Composer:      ${COLOR_BOLD}$([ "$INSTALL_COMPOSER" = true ] && echo "Yes" || echo "No")${COLOR_NC}"
    echo "  Node:          ${COLOR_BOLD}$([ "$INSTALL_NODE" = true ] && echo "Yes ($SELECTED_RUNTIME)" || echo "No")${COLOR_NC}"
    echo ""
    echo -n "Proceed with installation? [y/N]: "
    read -r confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        print_success "Starting installation..."
    else
        print_warning "Installation cancelled by user."
        exit 0
    fi
}

# ==============================================================================
# INSTALLATION PROCESS
# ==============================================================================

clone_repository() {
    print_step "1" "$STEP_CLONE_REPO"
    
    if git clone "$REPO_URL" "$PROJECT_NAME" > /dev/null 2>&1; then
        print_success "Repository cloned to '$PROJECT_NAME'"
    else
        print_error "Failed to clone repository"
        print_warning "Please check your internet connection and try again."
        exit 1
    fi
}

enter_project_directory() {
    print_step "2" "$STEP_ENTER_DIR"
    
    cd "$PROJECT_NAME" || exit 1
    print_success "Changed to project directory"
}

checkout_branch() {
    print_step "3" "$STEP_CHECKOUT_BRANCH"
    
    if git checkout "$SELECTED_BRANCH" > /dev/null 2>&1; then
        print_success "Switched to branch '$SELECTED_BRANCH'"
    else
        print_error "Failed to checkout branch '$SELECTED_BRANCH'"
        exit 1
    fi
}

cleanup_files() {
    print_step "4" "$STEP_CLEANUP"
    
    local removed_count=0
    
    # Remove folders
    for folder in "${CLEANUP_FOLDERS[@]}"; do
        if [ -d "$folder" ]; then
            rm -rf "$folder"
            ((removed_count++))
        fi
    done
    
    # Remove files
    for file in "${CLEANUP_FILES[@]}"; do
        if [ -f "$file" ]; then
            rm -f "$file"
            ((removed_count++))
        fi
    done
    
    print_success "Removed $removed_count unnecessary file(s)/folder(s)"
}

setup_environment() {
    print_step "5" "$STEP_ENV_SETUP"
    
    # Copy .env.example to .env
    if [ -f "$ENV_SOURCE_FILE" ]; then
        cp "$ENV_SOURCE_FILE" "$ENV_TARGET_FILE"
        print_success "Created .env file"
    else
        print_warning "$ENV_SOURCE_FILE not found, skipping .env creation"
    fi
    
    # Generate Laravel app key
    if [ "$ARTISAN_KEY_GENERATE" = true ] && command -v php &> /dev/null; then
        if php artisan key:generate > /dev/null 2>&1; then
            print_success "Generated application key"
        else
            print_warning "Failed to generate application key"
        fi
    fi
}

install_dependencies() {
    # Install Composer dependencies
    if [ "$INSTALL_COMPOSER" = true ]; then
        print_step "6a" "Installing Composer dependencies..."
        
        if eval "$COMPOSER_INSTALL_CMD" > /dev/null 2>&1; then
            print_success "Composer dependencies installed"
        else
            print_error "Failed to install Composer dependencies"
            exit 1
        fi
    fi
    
    # Install Node dependencies
    if [ "$INSTALL_NODE" = true ]; then
        print_step "6b" "Installing Node dependencies with $SELECTED_RUNTIME..."
        
        local install_cmd=""
        case $SELECTED_RUNTIME in
            npm)
                install_cmd="$NPM_INSTALL_CMD"
                ;;
            pnpm)
                install_cmd="$PNPM_INSTALL_CMD"
                ;;
            yarn)
                install_cmd="$YARN_INSTALL_CMD"
                ;;
            bun)
                install_cmd="$BUN_INSTALL_CMD"
                ;;
        esac
        
        if eval "$install_cmd" > /dev/null 2>&1; then
            print_success "Node dependencies installed with $SELECTED_RUNTIME"
        else
            print_error "Failed to install Node dependencies"
            exit 1
        fi
    fi
}

# ==============================================================================
# COMPLETION
# ==============================================================================

print_completion() {
    echo ""
    print_section "$COMPLETION_TITLE"
    echo ""
    echo -e "${COLOR_GREEN}$COMPLETION_MESSAGE${COLOR_NC}"
    echo ""
    echo "  ${COLOR_BOLD}Project:${COLOR_NC} $PROJECT_NAME"
    echo "  ${COLOR_BOLD}Branch:${COLOR_NC} $SELECTED_BRANCH"
    echo "  ${COLOR_BOLD}Runtime:${COLOR_NC} $SELECTED_RUNTIME"
    echo ""
    
    if [ "$INSTALL_COMPOSER" = false ] || [ "$INSTALL_NODE" = false ]; then
        echo -e "${COLOR_YELLOW}Note:${COLOR_NC} Some dependencies were not installed automatically."
        echo "You may need to run the following commands manually:"
        [ "$INSTALL_COMPOSER" = false ] && echo "  - composer install"
        [ "$INSTALL_NODE" = false ] && echo "  - $SELECTED_RUNTIME install"
        echo ""
    fi
    
    echo "$COMPLETION_NEXT_STEPS"
    echo ""
    echo "  ${COLOR_GRAY}cd $PROJECT_NAME${COLOR_NC}"
    echo "  ${COLOR_GRAY}php artisan serve${COLOR_NC}"
    echo ""
    echo -e "${COLOR_CYAN}Happy coding!${COLOR_NC}"
    echo ""
}

# ==============================================================================
# MAIN WORKFLOW
# ==============================================================================

main() {
    print_banner
    
    check_dependencies
    get_project_name
    get_branch
    get_runtime
    get_auto_install
    confirm_installation
    
    echo ""
    print_section "Installing"
    echo ""
    
    clone_repository
    enter_project_directory
    checkout_branch
    cleanup_files
    setup_environment
    install_dependencies
    
    print_completion
}

# Run main function
main
