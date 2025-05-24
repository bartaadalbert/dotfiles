# 🔧 Dotfiles

> Personal configuration files for macOS development environment

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![macOS](https://img.shields.io/badge/macOS-supported-brightgreen.svg)](https://www.apple.com/macos/)

## 🚀 Quick Start

**One-line installation:**

```bash
curl -fsSL https://raw.githubusercontent.com/bartaadalbert/dotfiles/master/install.sh | bash
```

## 📦 What's Included

This dotfiles repository contains configurations for:

- **🐚 Shell**: Zsh with custom prompt and aliases
- **📝 Editor**: Vim with plugins and custom keybindings  
- **📁 Git**: Global configuration and ignore patterns
- **🔧 Terminal**: Bash fallback configuration
- **⚙️ System**: macOS-specific optimizations

### Configuration Files

| File | Description |
|------|-------------|
| `.zshrc` | Zsh shell configuration with aliases, functions, and prompt |
| `.vimrc` | Vim editor settings, plugins, and keybindings |
| `.gitconfig` | Git global settings (user, aliases, colors) |
| `.gitignore_global` | Global gitignore patterns for common files |
| `.bashrc` | Bash shell configuration (fallback) |
| `install.sh` | Automated installation script |

## 🛠️ Installation

### Automatic Installation (Recommended)

```bash
# Download and run the install script
curl -fsSL https://raw.githubusercontent.com/bartaadalbert/dotfiles/master/install.sh | bash
```

### Manual Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/bartaadalbert/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the install script:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **Restart your terminal or source the configuration:**
   ```bash
   source ~/.zshrc  # or ~/.bashrc
   ```

## 🎯 Features

### Zsh Configuration
- **Custom prompt** with git status and current directory
- **Useful aliases** for common commands
- **Auto-completion** enhancements
- **History optimization** 
- **macOS-specific** shortcuts

### Vim Configuration
- **Syntax highlighting** for multiple languages
- **Custom keybindings** for productivity
- **Plugin management** ready
- **Search and navigation** improvements

### Git Configuration
- **User settings** (you'll need to customize these)
- **Helpful aliases** for common git operations
- **Color output** for better readability
- **Global ignore patterns** for common unwanted files

## ⚙️ Prerequisites

- **macOS** (tested on recent versions)
- **Git** (usually pre-installed)
- **Zsh** (default shell on macOS Catalina+)
- **Vim** (pre-installed on macOS)

## 🎨 Customization

### Personal Information

After installation, update your git configuration:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Zsh Customization

Edit `~/.zshrc` to:
- Add your own aliases
- Modify the prompt
- Add custom functions
- Set environment variables

### Vim Customization

Edit `~/.vimrc` to:
- Add your preferred plugins
- Customize keybindings
- Adjust color schemes
- Configure language-specific settings

## 📂 Directory Structure

```
~/.dotfiles/
├── .bashrc              # Bash configuration
├── .gitconfig           # Git global settings
├── .gitignore_global    # Global git ignore patterns
├── .vimrc               # Vim configuration
├── .zshrc               # Zsh configuration
├── install.sh           # Installation script
└── README.md            # This file
```

## 🔄 Updating

To update your dotfiles:

```bash
cd ~/.dotfiles
git pull origin master
./install.sh  # Re-run installer if needed
```

## 🚨 Backup

The install script automatically backs up your existing dotfiles by renaming them with a `.backup` extension:

```bash
~/.zshrc      → ~/.zshrc.backup
~/.vimrc      → ~/.vimrc.backup  
~/.gitconfig  → ~/.gitconfig.backup
~/.bashrc     → ~/.bashrc.backup
```

To restore your original configurations:
```bash
# Example for zsh
mv ~/.zshrc.backup ~/.zshrc

# Or restore all at once
for file in ~/.*.backup; do
    mv "$file" "${file%.backup}"
done
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by the dotfiles community
- Thanks to all the open-source projects that make this possible

---

**💡 Tip:** After installation, restart your terminal or open a new tab to see the changes!

## 📞 Support

If you encounter any issues:

1. **Check the backup files** in `~/*.backup`
2. **Review the install script output** for any error messages
3. **Open an issue** on GitHub with details about your setup

---

*Happy coding! 🚀*
