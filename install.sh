#!/bin/sh
# ~/.dotfiles/install.sh
# Compatible with both bash and sh, no sudo required
# Handles edge cases and fixes existing broken setups

set -e

# Colors for output (compatible with sh)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

printf "${GREEN}🚀 Setting up dotfiles...${NC}\n"

# Get the dotfiles directory
DOTFILES_DIR=""

# If running via curl, clone the repo first
if [ ! -d "$HOME/.dotfiles" ]; then
    printf "${YELLOW}Cloning dotfiles repository...${NC}\n"
    
    # Fix any broken git config before cloning
    if [ -L "$HOME/.gitconfig" ] && [ ! -f "$HOME/.gitconfig" ]; then
        printf "${YELLOW}Removing broken git config symlink...${NC}\n"
        rm -f "$HOME/.gitconfig"
    fi
    
    if command -v git >/dev/null 2>&1; then
        git clone https://github.com/bartaadalbert/dotfiles.git "$HOME/.dotfiles"
        DOTFILES_DIR="$HOME/.dotfiles"
    else
        printf "${RED}Error: git is not installed. Please install git first.${NC}\n"
        exit 1
    fi
else
    DOTFILES_DIR="$HOME/.dotfiles"
    printf "${BLUE}Using existing dotfiles directory: $DOTFILES_DIR${NC}\n"
    
    # Update existing repo
    printf "${YELLOW}Updating dotfiles repository...${NC}\n"
    cd "$DOTFILES_DIR"
    git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || printf "${YELLOW}Could not update repo${NC}\n"
fi

# Detect current shell
CURRENT_SHELL=$(basename "$SHELL")
printf "${BLUE}Current shell: $CURRENT_SHELL${NC}\n"

# Function to safely remove existing files/symlinks
safe_remove() {
    target="$1"
    if [ -L "$target" ]; then
        printf "${YELLOW}Removing existing symlink: $target${NC}\n"
        rm -f "$target"
    elif [ -f "$target" ]; then
        printf "${YELLOW}Backing up existing file: $target -> $target.backup$(date +%s)${NC}\n"
        mv "$target" "$target.backup$(date +%s)"
    fi
}

# Function to create symlinks safely
create_symlink() {
    src="$1"
    dest="$2"
    
    # Remove any existing file/symlink first
    safe_remove "$dest"
    
    # Ensure source file exists before creating symlink
    if [ -f "$src" ]; then
        printf "${GREEN}Creating symlink: $dest -> $src${NC}\n"
        ln -sf "$src" "$dest"
        return 0
    else
        printf "${RED}Warning: Source file $src not found, skipping symlink${NC}\n"
        return 1
    fi
}

# Special handling for ZSH - oh-my-zsh creates its own .zshrc
handle_zsh_config() {
    # If oh-my-zsh is installed, it may have created a .zshrc
    if [ -d "$HOME/.oh-my-zsh" ]; then
        printf "${YELLOW}oh-my-zsh detected, handling .zshrc carefully...${NC}\n"
        
        # Remove any existing zsh configs
        safe_remove "$HOME/.zshrc"
        safe_remove "$HOME/.zshrc.pre-oh-my-zsh"
        
        # Create our symlink
        if [ -f "$DOTFILES_DIR/.zshrc" ]; then
            ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
            printf "${GREEN}Created .zshrc symlink${NC}\n"
        fi
    else
        # Standard symlink creation
        create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    fi
}

# Create symlinks for dotfiles
printf "${BLUE}Creating symlinks for dotfiles...${NC}\n"
create_symlink "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"

# Handle .zshrc specially
handle_zsh_config

# Set up git to use global gitignore (only if git is available and .gitconfig exists)
if command -v git >/dev/null 2>&1 && [ -f "$HOME/.gitconfig" ]; then
    git config --global core.excludesfile ~/.gitignore_global
    printf "${GREEN}Configured git to use global gitignore${NC}\n"
fi

# Detect OS
if [ "$(uname)" = "Darwin" ]; then
    printf "${GREEN}🍎 Detected macOS${NC}\n"
    OS="macos"
elif [ "$(uname)" = "Linux" ]; then
    printf "${GREEN}🐧 Detected Linux${NC}\n"
    OS="linux"
else
    printf "${YELLOW}Unknown OS, skipping package installation${NC}\n"
    OS="unknown"
fi

# Install dependencies without sudo
install_dependencies() {
    if [ "$OS" = "macos" ]; then
        # Check for Homebrew
        if ! command -v brew >/dev/null 2>&1; then
            printf "${YELLOW}Homebrew not found. Installing Homebrew (this may take a while)...${NC}\n"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Add Homebrew to PATH for this session
            if [ -f "/opt/homebrew/bin/brew" ]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            elif [ -f "/usr/local/bin/brew" ]; then
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        fi
        
        # Install packages via Homebrew (no sudo needed)
        if command -v brew >/dev/null 2>&1; then
            printf "${YELLOW}Installing packages via Homebrew...${NC}\n"
            brew install git bash-completion zsh 2>/dev/null || true
        fi
        
    elif [ "$OS" = "linux" ]; then
        printf "${YELLOW}Linux detected. Installing user-level components...${NC}\n"
        
        # Always download git-prompt for Linux
        if [ ! -f "$HOME/.git-prompt.sh" ]; then
            printf "${YELLOW}Downloading git-prompt.sh...${NC}\n"
            curl -o "$HOME/.git-prompt.sh" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh 2>/dev/null || true
        fi
        
        # Show helpful commands for manual installation
        printf "${BLUE}For additional features, consider installing:${NC}\n"
        if command -v apt-get >/dev/null 2>&1; then
            printf "${BLUE}  sudo apt-get install git vim curl bash-completion zsh${NC}\n"
        elif command -v yum >/dev/null 2>&1; then
            printf "${BLUE}  sudo yum install git vim curl bash-completion zsh${NC}\n"
        fi
    fi
}

# Install oh-my-zsh and plugins
install_oh_my_zsh() {
    if command -v zsh >/dev/null 2>&1; then
        if [ ! -d "$HOME/.oh-my-zsh" ]; then
            printf "${YELLOW}Installing oh-my-zsh...${NC}\n"
            sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
            
            # After oh-my-zsh installation, fix the .zshrc again
            printf "${YELLOW}Fixing .zshrc after oh-my-zsh installation...${NC}\n"
            handle_zsh_config
        fi
        
        # Install useful plugins
        if [ -d "$HOME/.oh-my-zsh" ]; then
            printf "${YELLOW}Installing/updating zsh plugins...${NC}\n"
            
            # zsh-autosuggestions
            if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
                printf "${YELLOW}Installing zsh-autosuggestions...${NC}\n"
                git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" 2>/dev/null || true
            else
                printf "${GREEN}✅ zsh-autosuggestions already installed${NC}\n"
            fi
            
            # zsh-syntax-highlighting
            if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
                printf "${YELLOW}Installing zsh-syntax-highlighting...${NC}\n"
                git clone https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" 2>/dev/null || true
            else
                printf "${GREEN}✅ zsh-syntax-highlighting already installed${NC}\n"
            fi
        fi
    else
        printf "${BLUE}zsh not available, skipping oh-my-zsh installation${NC}\n"
    fi
}

# Install git-prompt for better git integration
install_git_prompt() {
    if [ "$OS" = "macos" ]; then
        if command -v brew >/dev/null 2>&1; then
            printf "${GREEN}Git completion should be available via Homebrew${NC}\n"
        else
            printf "${YELLOW}Downloading git-prompt.sh...${NC}\n"
            curl -o "$HOME/.git-prompt.sh" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh 2>/dev/null || true
        fi
    elif [ "$OS" = "linux" ]; then
        # Already handled in install_dependencies for Linux
        printf "${GREEN}Git prompt setup completed${NC}\n"
    fi
}

# Run installations
printf "${BLUE}Installing dependencies and tools...${NC}\n"
install_dependencies
install_git_prompt
install_oh_my_zsh

# Verify installation
printf "${BLUE}Verifying installation...${NC}\n"
printf "Dotfiles directory contents:\n"
ls -la "$DOTFILES_DIR" 2>/dev/null || printf "Could not list dotfiles directory\n"

printf "\nHome directory symlinks:\n"
ls -la "$HOME" | grep '\->' | grep -E '\.(bashrc|zshrc|vimrc|gitconfig|gitignore_global)' || printf "No dotfiles symlinks found\n"

printf "${GREEN}✅ Dotfiles setup complete!${NC}\n"
printf "\n"
printf "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
printf "${GREEN}Next steps:${NC}\n"
printf "1. Update your name and email in ~/.gitconfig\n"
printf "\n"

# Provide shell-specific sourcing instructions
printf "${YELLOW}To activate your new configuration:${NC}\n"

if [ "$CURRENT_SHELL" = "zsh" ]; then
    printf "${GREEN}  source ~/.zshrc${NC}   (for zsh)\n"
    printf "  ${BLUE}or${NC}\n"
    printf "${GREEN}  exec zsh${NC}         (restart zsh)\n"
elif [ "$CURRENT_SHELL" = "bash" ]; then
    printf "${GREEN}  source ~/.bashrc${NC}  (for bash)\n"
    printf "  ${BLUE}or${NC}\n"
    printf "${GREEN}  exec bash${NC}        (restart bash)\n"
else
    printf "${GREEN}  source ~/.bashrc${NC}  (for bash)\n"
    printf "${GREEN}  source ~/.zshrc${NC}   (for zsh)\n"
fi

printf "\n"
printf "${YELLOW}Optional: Switch to zsh (if not already using it):${NC}\n"
printf "${GREEN}  chsh -s \$(which zsh)${NC}\n"
printf "\n"

printf "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
