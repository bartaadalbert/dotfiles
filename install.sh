#!/bin/bash
# ~/.dotfiles/install.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Setting up dotfiles...${NC}"

# Get the dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Detect current shell
CURRENT_SHELL=$(basename "$SHELL")
echo -e "${BLUE}Current shell: $CURRENT_SHELL${NC}"

# Function to create symlinks
create_symlink() {
    local src="$1"
    local dest="$2"
    
    if [ -L "$dest" ]; then
        echo -e "${YELLOW}Removing existing symlink: $dest${NC}"
        rm "$dest"
    elif [ -f "$dest" ]; then
        echo -e "${YELLOW}Backing up existing file: $dest -> $dest.backup${NC}"
        mv "$dest" "$dest.backup"
    fi
    
    echo -e "${GREEN}Creating symlink: $dest -> $src${NC}"
    ln -sf "$src" "$dest"
}

# Create symlinks for dotfiles
create_symlink "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"

# Set up git to use global gitignore
git config --global core.excludesfile ~/.gitignore_global

# Detect OS and install dependencies
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${GREEN}🍎 Detected macOS${NC}"
    # Install Homebrew if not present
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}Installing Homebrew...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for this session
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f "/usr/local/bin/brew" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
    
    # Install git completion
    if ! brew list bash-completion &> /dev/null; then
        echo -e "${YELLOW}Installing bash completion...${NC}"
        brew install bash-completion
    fi
    
    # Install zsh if not available
    if ! command -v zsh &> /dev/null; then
        echo -e "${YELLOW}Installing zsh...${NC}"
        brew install zsh
    fi
    
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "${GREEN}🐧 Detected Linux${NC}"
    
    # Update package list
    if command -v apt-get &> /dev/null; then
        echo -e "${YELLOW}Updating package list...${NC}"
        sudo apt-get update
        
        # Install essentials
        sudo apt-get install -y git vim curl bash-completion zsh
    elif command -v yum &> /dev/null; then
        echo -e "${YELLOW}Installing packages via yum...${NC}"
        sudo yum install -y git vim curl bash-completion zsh
    fi
fi

# Install oh-my-zsh if zsh is available and oh-my-zsh isn't installed
if command -v zsh &> /dev/null && [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}Installing oh-my-zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # Install useful plugins
    echo -e "${YELLOW}Installing zsh plugins...${NC}"
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions 2>/dev/null || true
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting 2>/dev/null || true
fi

# Install git-prompt if not available
install_git_prompt() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew >/dev/null 2>&1; then
            echo -e "${YELLOW}Git completion should be available via Homebrew${NC}"
        else
            echo -e "${YELLOW}Downloading git-prompt.sh...${NC}"
            curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if ! find /usr -name "*git-prompt*" 2>/dev/null | grep -q git-prompt; then
            echo -e "${YELLOW}Downloading git-prompt.sh...${NC}"
            curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
        fi
    fi
}

install_git_prompt

echo -e "${GREEN}✅ Dotfiles setup complete!${NC}"
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Next steps:${NC}"
echo "1. Update your name and email in ~/.gitconfig"
echo ""

# Provide shell-specific sourcing instructions
echo -e "${YELLOW}To activate your new configuration:${NC}"

if [[ "$CURRENT_SHELL" == "zsh" ]]; then
    echo -e "${GREEN}  source ~/.zshrc${NC}   (for zsh)"
    echo -e "  ${BLUE}or${NC}"
    echo -e "${GREEN}  exec zsh${NC}         (restart zsh)"
elif [[ "$CURRENT_SHELL" == "bash" ]]; then
    echo -e "${GREEN}  source ~/.bashrc${NC}  (for bash)"
    echo -e "  ${BLUE}or${NC}"
    echo -e "${GREEN}  exec bash${NC}        (restart bash)"
else
    echo -e "${GREEN}  source ~/.bashrc${NC}  (for bash)"
    echo -e "${GREEN}  source ~/.zshrc${NC}   (for zsh)"
fi

echo ""
echo -e "${YELLOW}Optional: Switch to zsh (if not already using it):${NC}"
echo -e "${GREEN}  chsh -s \$(which zsh)${NC}"
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
