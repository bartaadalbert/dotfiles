# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_DISABLE_COMPFIX="true"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="agnoster"
#ZSH_THEME="jonathan"
ZSH_THEME="dst"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(git)
plugins=(git colored-man-pages colorize pip python brew macos zsh-autosuggestions zsh-syntax-highlighting kube-ps1)
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias python=python3
alias pip=pip3
alias d=docker
alias tf=terraform
alias k=kubectl
alias m=minikube
alias p=podman
# alias ll="ls -laht"
alias nn=nano
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfa="terraform apply"
alias tfd="terraform destroy"
alias tfv="terraform validate"
alias tfs="terraform state list"
alias i=infracost
alias kswitch-car='kubectl config use-context car'
alias kswitch-my='kubectl config use-context my'
alias kpod='kubectl get pods -A'
alias knode='kubectl get nodes'
alias kdesp='kubectl describe pod'
alias kdp='kubectl delete pod'
alias kep='kubectl edit pod'
alias kgd='kubectl get deployments'
alias a=ansible
alias ap=ansible-playbook
alias av=ansible-vault
alias al=ansible-lint

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias glog='git log --oneline --graph --decorate'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
#alias ls='ls --color=auto'
#alias grep='grep --color=auto'

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

#PROMPT='%F{39}%n%f@%F{121}%m:%F{221}%~%f$'
#PROMPT+='%{$fg[red]%}$(virtualenv_prompt_info) %{$reset_color%}%'
#export PS1="api@api-pro %1~ %# "
#PROMPT='%(?.%F{blue}√.%F{red}?%?)%f %B%F{240}%1~%f% '
#PROMPT='%F{39}%n%f@%F{119}%m:%F{227}%~%f %F{240}[%*]%f%# ' 

#PS1='%F{44}apple%f@%F{136}apple-pro:%F{223}%~%f$'
PS1='%F{44}apple%f@%F{136}apple-pro:%F{223}%1~$'
PS1+='%{$fg[red]%}$(virtualenv_prompt_info) '

#PS1='%F{44}apple%f@%F{136}apple-pro:%F{223}%~%f$'
#PS1+=' %{$fg[red]%}${PWD##*/} '

#PS1='%F{44}apple%f@%F{136}apple-pro:%F{223}%~%f\n'
#PS1+=' %{$fg[red]%}$(virtualenv_prompt_info) '


export LESS="RS"
compdef __start_kubectl k

export PATH=$HOME/bin:/usr/local/bin:$PATH
PROMPT='$(kube_ps1)'$PROMPT # or RPROMPT='$(kube_ps1)'
