# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=~/go/bin:$PATH
export PATH=$HOME/.rbenv/bin:$PATH
export PATH=/home/jhiggins/.local/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/sbin:$PATH
export PATH=$PATH:~/.dotnet/tools
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

TERM="screen-256color"
export TERM

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="af-magic"

## set colors for LS_COLORS
eval `dircolors ~/.dircolors`

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
DISABLE_AUTO_TITLE="true"

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
plugins=(
    git
    zsh-autosuggestions
)

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
export EDITOR='nvim'

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


##########################
## Custom configuration ##
##########################

# Completions
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if ( ! kubectl 2> /dev/null ); then
    NC='\033[0m' # No Color
    YELLOW='\033[0;33m'
    echo "${YELLOW}!! WARNING: Docker Desktop not running! 'kubectl' will not work until it is !!${NC}"
else
    source <(kubectl completion zsh)
fi


# Open zshrc from anywhere
alias zshrc='nvim ~/.config/.zshrc'

# Alias pbcopy to use xclip
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# Alias for capturing outputs
# capture the output of a command so it can be retrieved with ret
cap () { tee /tmp/capture.out; }

# return the output of the most recent command that was captured by cap
ret () { cat /tmp/capture.out; }

ul_massupdate='~/massupdate_ul'

ultralist_g() {
    cd ~/ultralist/

    echo "running ultra_g for $1 ${@:2}"
    if [[ "$1" == 'c' ]]; then
      echo "$1 equals 'c'"
      ultralist e "${@:2}" due:tod
    fi

    ultralist "$1" "${@:2}"
    clear
    tmux send-keys -t std-dev:tasklist.0 'ul_later' Enter
    tmux send-keys -t std-dev:tasklist.1 'ul_def' Enter
    tmux send-keys -t std-dev:tasklist.2 'ul_comp' Enter
    cd -
}

#############
## ALIASES ##
#############

# > Ultralist

# Add task
alias -g ula='ultralist_g a'

# Add note
alias -g ulan='ultralist_g an'

# List
alias -g ull='ultralist_g l'

# List with notes
alias -g uln='ultralist_g ln'

# Expand subject (req ID)
alias -g ule='ultralist_g e'

# Edit note (req ID)
alias -g ulen='ultralist_g en'

# Complete task (req ID)
alias -g ulc='ultralist_g c'

# Mass update tasks
alias -g ul_massupdate='source ~/.local/cli_utils/massupdate_ul'

# Default view, clearscreen list incompletes
alias -g ul_def='cd ~/ultralist/;clear;ultralist list --notes completed:false group:project status:-later;cd -'

# Default view, clearscreen list all completed today
alias -g ul_comp='cd ~/ultralist/;clear;ultralist list completed:true due:tod group:project status:-later;cd -'

# Default view, clearscreen list all later tasks
alias -g ul_later='cd ~/ultralist/;clear;ultralist list status:later group:project;cd -'

# > Dotnet help
# Build and publish a win64 non-self-contained build
alias dn_pub='dotnet build;dotnet publish -r win-x64 --no-self-contained'

# > Config Management
# copy my dotfiles and create a commit
eval "$(~/.rbenv/bin/rbenv init - zsh)"

# > Docker
# I don't want to type sudo docker everytime
alias dock='docker'

# > Terraform
# I don't want to type sudo terraform every time
alias tf='terraform'

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
