#!/bin/sh
# ~/.dotfiles/install.sh
# Compatible with both bash and sh, no sudo required

set -e

# Colors for output (compatible with sh)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

printf "${GREEN}🚀 Setting up dotfiles...${NC}\n"

# Get the dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

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
fi

# Detect current shell
CURRENT_SHELL=$(basename "$SHELL")
printf "${BLUE}Current shell: $CURRENT_SHELL${NC}\n"

# Function to create symlinks safely
create_symlink() {
    src="$1"
    dest="$2"
    
    # Remove any existing symlink (even if broken)
    if [ -L "$dest" ]; then
        printf "${YELLOW}Removing existing symlink: $dest${NC}\n"
        rm -f "$dest"
    elif [ -f "$dest" ]; then
        printf "${YELLOW}Backing up existing file: $dest -> $dest.backup${NC}\n"
        mv "$dest" "$dest.backup"
    fi
    
    # Ensure source file exists before creating symlink
    if [ -f "$src" ]; then
        printf "${GREEN}Creating symlink: $dest -> $src${NC}\n"
        ln -sf "$src" "$dest"
    else
        printf "${RED}Warning: Source file $src not found, skipping symlink${NC}\n"
    fi
}

# Create symlinks for dotfiles
create_symlink "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"

# Set up git to use global gitignore
if command -v git >/dev/null 2>&1; then
    git config --global core.excludesfile ~/.gitignore_global
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
        printf "${YELLOW}Linux detected. Checking for user-level package managers...${NC}\n"
        
        # Check if we can install without sudo using existing tools
        if command -v apt-get >/dev/null 2>&1; then
            printf "${BLUE}Note: Some packages might need manual installation.${NC}\n"
            printf "${BLUE}Consider running: sudo apt-get install git vim curl bash-completion zsh${NC}\n"
        elif command -v yum >/dev/null 2>&1; then
            printf "${BLUE}Note: Some packages might need manual installation.${NC}\n"
            printf "${BLUE}Consider running: sudo yum install git vim curl bash-completion zsh${NC}\n"
        fi
        
        # Try to install user-level tools
        # Install git-prompt manually if not available
        if ! find /usr -name "*git-prompt*" 2>/dev/null | grep -q git-prompt; then
            printf "${YELLOW}Downloading git-prompt.sh...${NC}\n"
            curl -o "$HOME/.git-prompt.sh" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh 2>/dev/null || true
        fi
    fi
}

# Install oh-my-zsh if zsh is available and oh-my-zsh isn't installed
install_oh_my_zsh() {
    if command -v zsh >/dev/null 2>&1 && [ ! -d "$HOME/.oh-my-zsh" ]; then
        printf "${YELLOW}Installing oh-my-zsh...${NC}\n"
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 2>/dev/null || true
        
        # Install useful plugins
        if [ -d "$HOME/.oh-my-zsh" ]; then
            printf "${YELLOW}Installing zsh plugins...${NC}\n"
            git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" 2>/dev/null || true
            git clone https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" 2>/dev/null || true
        fi
    fi
}

# Install git-prompt for better git integration
install_git_prompt() {
    if [ "$OS" = "macos" ]; then
        if command -v brew >/dev/null 2>&1; then
            printf "${YELLOW}Git completion should be available via Homebrew${NC}\n"
        else
            printf "${YELLOW}Downloading git-prompt.sh...${NC}\n"
            curl -o "$HOME/.git-prompt.sh" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh 2>/dev/null || true
        fi
    elif [ "$OS" = "linux" ]; then
        if ! find /usr -name "*git-prompt*" 2>/dev/null | grep -q git-prompt; then
            printf "${YELLOW}Downloading git-prompt.sh...${NC}\n"
            curl -o "$HOME/.git-prompt.sh" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh 2>/dev/null || true
        fi
    fi
}

# Run installations
install_dependencies
install_oh_my_zsh
install_git_prompt

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

# Show what might need manual installation
if [ "$OS" = "linux" ]; then
    printf "${BLUE}If some features don't work, you might need to install:${NC}\n"
    printf "${BLUE}  sudo apt-get install git vim curl bash-completion zsh${NC}\n"
    printf "${BLUE}  (or equivalent for your package manager)${NC}\n"
    printf "\n"
fi

printf "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
