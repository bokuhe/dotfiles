typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
unset PREFIX
export DOTFILES_DIR="$HOME/dotfiles"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
  
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
  
# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"
  
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# Powerlevel10k (auto-install if missing)
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
  echo "Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi
ZSH_THEME="powerlevel10k/powerlevel10k"
  
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
  
# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"
  
# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"
  
# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13
  
# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"
  
# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"
  
# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"
  
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"
  
# Uncomment the following line to display red dots whilst waiting for completion.
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
plugins=(git)
  
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
  
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# Machine-local config takes priority; dotfiles default as fallback.
if [[ -f ~/.p10k.zsh ]]; then
  source ~/.p10k.zsh
elif [[ -f "$DOTFILES_DIR/shell/p10k.default.zsh" ]]; then
  source "$DOTFILES_DIR/shell/p10k.default.zsh"
fi
  
#-------------------------------------------------------------
# ZSH Custom Plugins (auto-install if missing)
#-------------------------------------------------------------
ZSH_CUSTOM_PLUGINS=(
  "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git"
  "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git"
  "zsh-z https://github.com/agkozak/zsh-z.git"
)

for plugin_entry in "${ZSH_CUSTOM_PLUGINS[@]}"; do
  plugin_name="${plugin_entry%% *}"
  plugin_url="${plugin_entry#* }"
  plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin_name"

  if [[ ! -d "$plugin_dir" ]]; then
    echo "Installing $plugin_name..."
    git clone --depth=1 "$plugin_url" "$plugin_dir"
  fi
done

# Source plugins (zsh-syntax-highlighting must be last)
source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-z/zsh-z.plugin.zsh
source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  
  
#============================================================
#
#  ALIASES AND FUNCTIONS
#  Arguably, some functions defined here are quite big.
#  If you want to make this file smaller, these functions can
#+ be converted into scripts and removed from here.
#
#============================================================
  
#---------------
# Color Settings
#---------------
#export CLICOLOR=1
#export LSCOLORS=GxFxCxDxBxegedabagaced
#export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#export CLICOLOR=1
#export LSCOLORS=GxFxCxDxBxegedabagaced
#export PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;34m\]\w\[\e[0m\]\$ '
#export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$'
  
#-------------------
# Personnal Aliases
#-------------------
  
#alias rm='rm -i'
if command -v rmtrash >/dev/null 2>&1; then
  alias rm='rmtrash'
fi

# rm .DS_Store
alias rmdsstore='echo "Delete all .DS_Store files in this directory and all subdirectories? (y/n): "; \
read yn; \
if [ "$yn" = "y" ] || [ "$yn" = "Y" ]; then \
    find . -name ".DS_Store" -type f -exec rm {} +; \
    echo "All .DS_Store files have been deleted."; \
fi'

alias cp='cp -i'
alias mv='mv -i'
alias cl='clear'
# -> Prevents accidentally clobbering files.
alias mkdir='mkdir -p'
  
alias h='history'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ..'
  
# Pretty-print of some PATH variables:
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
  
alias du='du -kh'    # Makes a more readable output.
alias df='df -kTh'
  
#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls).
#-------------------------------------------------------------
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Add colors for filetype and  human-readable sizes by default on 'ls':
  alias ls='ls -hG'
  # The ubiquitous 'll': directories first, with alphanumeric sorting:
  alias ll="ls -alv"
else
  # Linux
  alias ls='ls -h --color=auto'
  alias ll="ls -alv --color=auto"
fi
alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.
  
alias lm='ll |more'        #  Pipe through 'more'
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...
  
#-------------------------------------------------------------
# Tailoring 'less'
#-------------------------------------------------------------
  
alias more='less'
export PAGER=less
export LESSCHARSET='latin1'
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
                # Use this if lesspipe.sh exists.
export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'
  
# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
  
#-------------------------------------------------------------
# Using in MAC
#-------------------------------------------------------------
alias desk='cd ~/Desktop'
alias cl='clear'
alias cls='clear'
  
#-------------------------------------------------------------
# GREP Options
#-------------------------------------------------------------
#export GREP_OPTIONS='--color=always'
#export GREP_COLOR='1;35;40'
  
#-------------------------------------------------------------
# Homebrew
#-------------------------------------------------------------
if [ -d "/opt/homebrew/bin" ]; then
  # Apple Silicon Mac
  export PATH="/opt/homebrew/bin:$PATH"
elif [ -d "/usr/local/bin" ]; then
  # Intel Mac
  export PATH="/usr/local/bin:$PATH"
fi

#-------------------------------------------------------------
# Java (macOS only - uses Homebrew and /usr/libexec/java_home)
#-------------------------------------------------------------
if [[ "$OSTYPE" == "darwin"* ]]; then
  JDK_VERSION="17"

  # Determine Homebrew prefix
  if [ -d "/opt/homebrew/opt" ]; then
    HOMEBREW_PREFIX="/opt/homebrew"
  elif [ -d "/usr/local/opt" ]; then
    HOMEBREW_PREFIX="/usr/local"
  fi

  if [ -n "$HOMEBREW_PREFIX" ] && [ -d "$HOMEBREW_PREFIX/opt/openjdk@$JDK_VERSION/libexec/openjdk.jdk" ] && [ ! -L "/Library/Java/JavaVirtualMachines/openjdk-$JDK_VERSION.jdk" ]; then
    sudo ln -sfn "$HOMEBREW_PREFIX/opt/openjdk@$JDK_VERSION/libexec/openjdk.jdk" "/Library/Java/JavaVirtualMachines/openjdk-$JDK_VERSION.jdk"
  fi

  if JAVA_HOME=$(/usr/libexec/java_home -v $JDK_VERSION 2>/dev/null); then
    export JAVA_HOME
    export PATH="${PATH}:$JAVA_HOME/bin"
    export CPPFLAGS="-I$JAVA_HOME/include"
  fi
fi

#-------------------------------------------------------------
# SDKMAN (cross-platform JVM SDK manager — opt-in per machine)
#-------------------------------------------------------------
source "$DOTFILES_DIR/shell/sdkman.zsh"

#-------------------------------------------------------------
# Python
#-------------------------------------------------------------
alias pyhttp='python3 -m http.server'

#-------------------------------------------------------------
# Ruby 
#-------------------------------------------------------------
if [[ -d "$HOME/.rbenv" ]] && command -v rbenv &>/dev/null; then
  eval "$(rbenv init -)"
fi
  
#-------------------------------------------------------------
# Node 
#-------------------------------------------------------------
#NODE_PATH="/opt/homebrew/opt/node@16"
#[[ -d $NODE_PATH ]] && \
#export PATH="$NODE_PATH/bin:$PATH" && \
#export LDFLAGS="-L$NODE_PATH/lib" && \
#export CPPFLAGS="-I$NODE_PATH/include"
# sudo ln -s $(sh -c 'which node') /usr/local/bin/node
  
#-------------------------------------------------------------
# NVM
#-------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
    \. "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
  elif [ -s "/usr/local/opt/nvm/nvm.sh" ]; then
    \. "/usr/local/opt/nvm/nvm.sh"
    [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
  elif [ -s "$NVM_DIR/nvm.sh" ]; then
    \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  fi
else
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

#-------------------------------------------------------------
# Cargo (Rust)
#-------------------------------------------------------------
export PATH="$HOME/.cargo/bin:$PATH"
  
#-------------------------------------------------------------
# Android
#-------------------------------------------------------------
if [[ "$OSTYPE" == "darwin"* ]]; then
  export ANDROID_HOME=${HOME}/Library/Android/sdk
else
  export ANDROID_HOME=${HOME}/Android/Sdk
fi
if [[ -d "$ANDROID_HOME" ]]; then
  export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools/bin
fi

#-------------------------------------------------------------
# Flutter
#-------------------------------------------------------------
#export PATH="$HOME/flutter/bin:$PATH"
export PATH="$HOME/fvm/default/bin:$PATH"
  
#-------------------------------------------------------------
# Expo
#-------------------------------------------------------------
alias expo-init='pnpx create-expo-app -t expo-template-blank-typescript --no-install'
alias expo-init-web='yarn && npx expo install react-dom react-native-web @expo/webpack-config'
alias expo-web='env BROWSER=safari npx expo start --web'

#-------------------------------------------------------------
# React Native
#-------------------------------------------------------------
alias rn='pnpx react-native start'
alias rn-start='rn start'
alias rn-android='rn run-android'
alias rn-ios='rn run-ios'
#alias rn-init='npx react-native init --template react-native-template-typescript@6.10.3'
alias rn-init='pnpx @react-native-community/cli init --version 0.76.7 --skip-install'
alias rn-pod='cd ios && pod install && cd ..'
alias rn-gradle='cd android && sh gradlew build && cd ..'
alias rn-install='yarn && rn-pod && rn-gradle'
 
# RN Desktop
alias rn-init-macos='pnpx react-native-macos-init'
alias rn-macos='pnpx react-native run-macos'
alias rn-init-windows='pnpx react-native-windows-init --overwrite'
alias rn-windows='pnpx react-native run-windows'

#-------------------------------------------------------------
# React, Next, vite 
#-------------------------------------------------------------
alias react-init='pnpx create-react-app --template typescript'
alias next-init='pnpx create-next-app@latest --ts --eslint --src-dir --import-alias "@/*" --no-app --no-tailwind --use-yarn'
alias vite-init='yarn create vite -- --template react-ts'

#-------------------------------------------------------------
# Jekyll
#-------------------------------------------------------------
alias jekyll-serve='bundle exec jekyll serve'
alias jekyll-drafts='bundle exec jekyll serve --drafts'

#-------------------------------------------------------------
# Dotfiles
#-------------------------------------------------------------
if [[ -d "$DOTFILES_DIR/bin" ]]; then
  export PATH="$DOTFILES_DIR/bin:$PATH"
fi

#-------------------------------------------------------------
# Git
#-------------------------------------------------------------
source "$DOTFILES_DIR/shell/git.zsh"

#-------------------------------------------------------------
# MISC.
#-------------------------------------------------------------

# scrcpy
alias scrcpy="scrcpy --show-touches --stay-awake --no-audio -m 1024 --max-fps 60"

# Add VSCode (code)
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# Add Fork
#export PATH="/Applications/SourceTree.app/Contents/Resources:$PATH"  
if command -v fork > /dev/null 2>&1; then
    alias stree='fork'
fi

# Add Cursor.ai
#if command -v cursor > /dev/null 2>&1; then
#	alias code='cursor'
#fi

# Add IntelliJ
alias idea='open -na "IntelliJ IDEA.app" --args "$@"'

# Add AndroidStudio
alias asopen='open -na "Android Studio.app" --args "$@"'
alias asopen-preview='open -na "Android Studio Preview.app" --args "$@"'

# Add SublimeText
alias sublime='open -a "Sublime Text.app"'

# Add Typora
alias typora='open -a "Typora"'

# Add nvim (when installed)
if command -v nvim > /dev/null 2>&1; then
    alias vi='nvim'
    alias vim='nvim'
elif command -v vim > /dev/null 2>&1; then
    alias vi='vim'
fi

# Add open command (Linux only, macOS has it built-in)
if [[ "$(uname -r)" == *microsoft* ]] || [[ "$OSTYPE" == cygwin* ]]; then
    alias open="explorer.exe"
elif [[ "$(uname -s)" == "Linux" ]]; then
    alias open="xdg-open"
fi

# Add Zellij
alias zj='zellij'

#-------------------------------------------------------------
# Claude
#-------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"

#-------------------------------------------------------------
# Dotfiles update notification
#-------------------------------------------------------------
source "$DOTFILES_DIR/shell/update-check.zsh"

# OpenClaw Completion
[ -f "$HOME/.openclaw/completions/openclaw.zsh" ] && source "$HOME/.openclaw/completions/openclaw.zsh"
