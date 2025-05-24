# ~/.bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend
shopt -s checkwinsize

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Colored prompt
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# Enhanced Git prompt (cross-platform)
# Check for git-prompt.sh in common locations
GIT_PROMPT_LOCATIONS=(
    "/usr/local/etc/bash_completion.d/git-prompt.sh"  # macOS with Homebrew
    "/Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh"  # macOS Xcode
    "/usr/share/git-core/contrib/completion/git-prompt.sh"  # Ubuntu/CentOS
    "/etc/bash_completion.d/git-prompt"  # Some Ubuntu versions
    "$HOME/.git-prompt.sh"  # Manual installation
)

for git_prompt in "${GIT_PROMPT_LOCATIONS[@]}"; do
    if [ -f "$git_prompt" ]; then
        source "$git_prompt"
        export GIT_PS1_SHOWDIRTYSTATE=1
        export GIT_PS1_SHOWSTASHSTATE=1
        export GIT_PS1_SHOWUNTRACKEDFILES=1
        export GIT_PS1_SHOWUPSTREAM="auto"
        export GIT_PS1_SHOWCOLORHINTS=1
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '
        break
    fi
done

# Fallback: Simple git branch in prompt without git-prompt.sh
if ! command -v __git_ps1 >/dev/null 2>&1; then
    function parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
    }
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '
fi

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias glog='git log --oneline --graph --decorate'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Python and Django aliases
alias py='python3'
alias pip='pip3'
alias manage='python manage.py'
alias runserver='python manage.py runserver'
alias migrate='python manage.py migrate'
alias makemigrations='python manage.py makemigrations'
alias shell='python manage.py shell'
alias collectstatic='python manage.py collectstatic --noinput'

# Virtual environment
alias activate='source venv/bin/activate'
alias deactivate='deactivate'
alias mkvenv='python3 -m venv venv'

# FastAPI development
alias uvicorn='uvicorn main:app --reload'
alias uvicorn-prod='uvicorn main:app --host 0.0.0.0 --port 8000'

# Node.js and npm
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nis='npm install --save'
alias nrun='npm run'
alias nstart='npm start'
alias ntest='npm test'
alias nbuild='npm run build'

# Package management
alias pipr='pip install -r requirements.txt'
alias pipf='pip freeze > requirements.txt'

# Database shortcuts
alias dbreset='python manage.py reset_db && python manage.py migrate'

# Network
alias myip="curl -s http://ipecho.net/plain; echo"
alias ports='netstat -tulanp'

# Directory operations
alias mkdir='mkdir -pv'
alias df='df -H'
alias du='du -ch'

# Safety nets
alias rm='rm -I --preserve-root'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'

# Export settings
export EDITOR='vim'
export PAGER='less'
export BROWSER='firefox'

# Add local bin to PATH if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
